import boto3
import numpy
import pandas as pd
import os
import json
from datetime import datetime
import traceback

def lambda_handler(event, context):
    try:
        dynamodb = boto3.resource('dynamodb')
        s3 = boto3.resource('s3')
        table = dynamodb.Table(os.environ['GDPR_LOG_TABLE_NAME'])
        records = event['Records']
        for record in records:
            message = json.loads(record['body'])
            s3_key = message['Path']
            df = pd.read_parquet(s3_key, engine='pyarrow')
            print(len(df))
            identifier_column = message['table_key']
            anonymize_columns = []
            if 'anonymize_columns' in message:
                anonymize_columns = message['anonymize_columns']

            new_df, identifier_values = transform_dataframe(df, message, identifier_column, anonymize_columns)
            
            if len(new_df) > 0:
                for col in new_df.columns:
                    if col != 'timestamp':
                        new_df[col] = new_df[col].astype(str)
                new_df.to_parquet(message['Path'], index= False,compression='gzip', engine='pyarrow')
            else:
                path_parts = message['Path'].replace("s3://","").split("/")
                bucket_name = path_parts.pop(0)
                key = '/'.join(path_parts)
                object = s3.Object(bucket_name,key)
                object.delete()
            request_time = str(datetime.now())
            table.put_item(Item={'MessageId': record['messageId'],
                                 'anonymized_key': identifier_column,
                                 'anonymized_values': identifier_values,
                                 'S3Key':message['Path'],
                                 'CountBefore': len(df),
                                 'CountAfter': len(new_df),
                                 'RequestDateTime':request_time})
            print(f"Old file count is {len(df)} vs new file count: {len(new_df)}")
        return {'Success': True}
    except:
        print(event)
        print(traceback.format_exc())
        return {'Success': False, 'Event':event , 'Exception': traceback.format_exc()}

def transform_dataframe(dataframe, message, identifier_column, anonymize_columns):
    if 'Identifiers' in message:
        identifier_values = message['Identifiers']
        df = delete_rows_in_df(dataframe, identifier_column, identifier_values)
    elif 'AnonymizeIds' in message:
        identifier_values = message['AnonymizeIds']
        df = anonymize_rows_in_df(dataframe, identifier_column, identifier_values, anonymize_columns)
    else:
        raise ValueError("Unidentified message!")
    return df, identifier_values

def delete_rows_in_df(df, identifierColumn, identifier_values):
    return df[~df[identifierColumn].isin(list(map(str,identifier_values)))]

def anonymize_rows_in_df(df, identifierColumn, identifier_values, anonymize_columns):
    anonymized_value = '####'
    df_to_be_anonymised = df[identifierColumn].isin(list(map(str,identifier_values)))
    df.loc[df_to_be_anonymised, anonymize_columns] = anonymized_value
    return df