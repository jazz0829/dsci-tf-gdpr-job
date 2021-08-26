import boto3
import traceback

def lambda_handler(event, context):
    try:
        glue_client = boto3.client('glue')
        response = glue_client.get_crawler(Name=event['CrawlerName'])
        return {'Success': True, 'State': response['Crawler']['State']}
    except:
        print(traceback.format_exc())
        return {'Success': False, 'Exception': traceback.format_exc()}