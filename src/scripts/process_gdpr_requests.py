from pyspark import SparkContext
from pyspark.sql import SQLContext
from pyspark.sql.functions import col, collect_set, lit, udf, array, when
from pyspark.sql.types import *
from pyspark.sql.window import Window
import boto3, argparse, json, traceback
from datetime import datetime

def anonymize_rows_in_df(df, identifier_column, identifier_values, anonymize_columns):
    anonymized_value = '####'
    for anonymize_column in anonymize_columns:
        df = df.withColumn(anonymize_column, when(df[identifier_column].isin(list(map(str,identifier_values))),anonymized_value).otherwise(df[anonymize_column]))
    return df

if __name__ == "__main__":
    try:
        anonymized_value = '####'
        sc = SparkContext()
        spark = SQLContext(sparkContext=sc)
        sqs_client = boto3.client('sqs', region_name='eu-west-1')
        s3_client = boto3.client('s3', region_name='eu-west-1')
        dynamodb = boto3.resource('dynamodb', region_name='eu-west-1')
        parser = argparse.ArgumentParser(description="Process GDPR requests from SQS queue")
        parser.add_argument("--queue", '-q', type=str, required=True, help="SQS queue to read GDPR requests from.")
        parser.add_argument("--dynamodb_table", '-t', type=str, required=True, help="DynamoDB table to log GDPR requests results to.")
        conf = parser.parse_args()
        sqs_queue = conf.queue
        table_name = conf.dynamodb_table
        table = dynamodb.Table(table_name)
        response = sqs_client.get_queue_url(
            QueueName=sqs_queue
        )
        queue_url = response['QueueUrl']
        while True:
            messages = sqs_client.receive_message(QueueUrl=queue_url,MaxNumberOfMessages=1)
            if 'Messages' in messages: # when the queue is exhausted, the response dict contains no 'Messages' key
                for message in messages['Messages']: # 'Messages' is a list
                    print('processing message: '+ message['MessageId'])
                    gdpr_message = json.loads(message['Body'])
                    print(gdpr_message)
                    s3_path = gdpr_message['Path']
                    print('Reading file from: ' + s3_path)
                    df = spark.read.parquet(s3_path)
                    old_df_count = df.count()
                    print(old_df_count)
                    if 'Identifiers' in gdpr_message:
                        print('deleting data from the parquet file')
                        new_df = df.where(~col(gdpr_message['table_key']).isin(gdpr_message['Identifiers']))
                        anonymized_values = gdpr_message['Identifiers']
                    elif 'AnonymizeIds' in gdpr_message:
                        print('Anonymizing data from the parquet file')
                        identifier_column = gdpr_message['table_key']
                        anonymized_values = gdpr_message['AnonymizeIds']
                        anonymized_columns = gdpr_message['anonymize_columns'].split(',')
                        new_df = anonymize_rows_in_df(df,identifier_column, anonymized_values, anonymized_columns)
                    print('saving file to: '+ "/".join(s3_path.split("/")[:-1]))
                    new_df_count = new_df.count()
                    if new_df_count > 0:
                        new_df.repartition(1).write.mode("append").parquet("/".join(s3_path.split("/")[:-1]))
                    path_parts = s3_path.replace("s3://","").split("/")
                    bucket_name = path_parts.pop(0)
                    key = '/'.join(path_parts)
                    print('deleting file with key: '+ key)
                    s3_client.delete_object(
                        Bucket=bucket_name,
                        Key=key
                    )
                    request_time = str(datetime.now())
                    print('saving a log entry to dynamodb')
                    table.put_item(Item={'MessageId': message['MessageId'],
                                         'anonymized_key': gdpr_message['table_key'],
                                         'anonymized_values': anonymized_values,
                                         'S3Key':gdpr_message['Path'],
                                         'CountBefore': old_df_count,
                                         'CountAfter': new_df_count,
                                         'RequestDateTime':request_time})
                    # next, we delete the message from the queue so no one else will process it again
                    sqs_client.delete_message(QueueUrl=queue_url,ReceiptHandle=message['ReceiptHandle'])
            else:
                print('Queue is now empty')
                break
    except:
        print(traceback.format_exc())
        raise Exception('EMR process gdpr requests step failed.')