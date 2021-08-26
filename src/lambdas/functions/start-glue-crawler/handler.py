import boto3
import traceback

def lambda_handler(event, context):
    try:
        glue_client = boto3.client('glue')
        glue_client.start_crawler(Name=event['CrawlerName'])
        return {'Success': True}
    except:
        print(traceback.format_exc())
        return {'Success': False, 'Exception': traceback.format_exc()}