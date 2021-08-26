import boto3
import os
import traceback
from time import gmtime, strftime
import re

def lambda_handler(event, context):
    try:
        endpoint_name = event['EndpointName']
        dynamodb = boto3.resource('dynamodb', region_name='eu-west-1')
        sagemaker_client = boto3.client('sagemaker')
        table = dynamodb.Table(os.environ['BOOKMARK_TABLE'])
        bookmark = table.get_item(Key = {'EndpointName': endpoint_name})
        if bookmark is not None:
            endpoint_config_name = bookmark['Item']['EndpointConfigName']
            endpoint_details = sagemaker_client.describe_endpoint(EndpointName = endpoint_name)
            if endpoint_config_name != endpoint_details['EndpointConfigName']:
                sagemaker_client.update_endpoint(EndpointName = endpoint_name, EndpointConfigName = endpoint_config_name )
            else:
                new_endpoint_config = {}
                current_endpoint_config = sagemaker_client.describe_endpoint_config(
                    EndpointConfigName = endpoint_config_name
                )
                prefix = re.sub('(-[\d]{2,4}){6}','',current_endpoint_config['EndpointConfigName'])
                suffix = strftime("-%Y-%m-%d-%H-%M-%S", gmtime())
                new_endpoint_config['EndpointConfigName'] = prefix + suffix
                new_endpoint_config['ProductionVariants'] = current_endpoint_config['ProductionVariants']
                sagemaker_client.create_endpoint_config(**new_endpoint_config)
                sagemaker_client.update_endpoint(EndpointName = endpoint_name, EndpointConfigName = new_endpoint_config['EndpointConfigName'] )

            return {'success': True}
        else:
            print("No bookmark found for the given Sagemaker endpoint: " + endpoint_name)
            return {'success': False}
    except:
        print(traceback.format_exc())
        return {'success': False}