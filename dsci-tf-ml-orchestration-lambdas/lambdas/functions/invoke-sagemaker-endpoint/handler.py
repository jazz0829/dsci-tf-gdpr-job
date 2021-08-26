import boto3
import traceback

def lambda_handler(event, context):
    try:

        client = boto3.client('sagemaker-runtime')
        endpoint_name = event['EndpointName']
        request_body = event['RequestBody']

        response = client.invoke_endpoint(
            EndpointName=endpoint_name,
            Body=request_body,
            ContentType='application/json',
            Accept='application/json'
        )

        return {
            'success': response['ResponseMetadata']['HTTPStatusCode'] == 200
        }
    except:
        print(traceback.format_exc())
        return { 'success' : False , 'exception': traceback.format_exc()}