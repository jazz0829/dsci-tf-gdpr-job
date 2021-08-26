import boto3
import os
import traceback

def lambda_handler(event, context):

    try:
        endpoint_name = event['EndpointName']
        sagemaker_client = boto3.client('sagemaker')
        endpoint_config_name = sagemaker_client.describe_endpoint(EndpointName = endpoint_name)['EndpointConfigName']
        dynamodb = boto3.resource('dynamodb', region_name = 'eu-west-1')
        table = dynamodb.Table(os.environ['BOOKMARK_TABLE'])
        table.put_item(Item = {'EndpointName': endpoint_name, 'EndpointConfigName': endpoint_config_name})
        return {
            'success': True
        }
    except:
        print(traceback.format_exc())
        return {
            'success': False
        }