import json
import boto3


def lambda_handler(event, context):

    sagemakerClient = boto3.client('sagemaker')

    endpointName = event['inputs']['endpoint']['EndpointName']

    if 'rollback' not in event:
        event['rollback'] = {
            "endpoint_config": {
                "EndpointConfigArn": None
            }
        }

    endpointConfigArn = event['rollback']['endpoint_config']['EndpointConfigArn'] or event['results']['endpoint_config']['EndpointConfigArn']

    endpointConfigName = endpointConfigArn[endpointConfigArn.find(':endpoint-config/') + 17:]

    existingEndpoint = None
    inServiceEndpointConfigName = None

    try:
        existingEndpoint = sagemakerClient.describe_endpoint(EndpointName = endpointName)
        if existingEndpoint['EndpointStatus'] == 'InService':
            inServiceEndpointConfigName = existingEndpoint['EndpointConfigName']
    except Exception:
        pass

    updatedEndpoint = None

    if existingEndpoint:
        updatedEndpoint = sagemakerClient.update_endpoint(EndpointName = endpointName, EndpointConfigName = endpointConfigName )
    else:
        updatedEndpoint = sagemakerClient.create_endpoint(EndpointName = endpointName, EndpointConfigName = endpointConfigName )

    event['results']['endpoint'] = updatedEndpoint
    event['rollback']['endpoint_config']['EndpointConfigName'] = inServiceEndpointConfigName
    
    return {'EndpointArn': updatedEndpoint['EndpointArn']}
