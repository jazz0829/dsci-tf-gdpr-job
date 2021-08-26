import json
import boto3
from time import gmtime, strftime


def lambda_handler(event, context):
    sagemakerClient = boto3.client('sagemaker')
    config = event['inputs']['endpoint_configuration']

    config['EndpointConfigName'] = config['EndpointConfigName'] +\
        strftime("-%Y-%m-%d-%H-%M-%S", gmtime())
    config['ProductionVariants'][0]['ModelName'] = event['results']['created_model']['model_name']
    endpointConfig = sagemakerClient.create_endpoint_config(**config)
    
    return {'EndpointConfigArn' : endpointConfig['EndpointConfigArn']}
