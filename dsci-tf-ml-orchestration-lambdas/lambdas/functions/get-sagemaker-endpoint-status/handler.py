import json
import boto3
from time import gmtime, strftime


def lambda_handler(event, context):

    # Create a boto3 sagemaker client
    sagemakerClient = boto3.client('sagemaker')

    endpointArn = event['EndpointArn']

    endpointName = endpointArn[endpointArn.find(
        ':endpoint/') + 10:]

    status = None
    try:
        status = sagemakerClient.describe_endpoint(
            EndpointName=endpointName
        )['EndpointStatus']
    except Exception:
        pass

    return {'status': status,
            'name': endpointName
            }
