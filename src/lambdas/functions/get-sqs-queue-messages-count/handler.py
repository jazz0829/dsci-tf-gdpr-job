import boto3
import traceback

def lambda_handler(event, context):
    try:
        queue_name = event['QueueName']
        client = boto3.client('sqs')
        response = client.get_queue_url(QueueName=queue_name)
        queue = client.get_queue_attributes(QueueUrl=response['QueueUrl'], AttributeNames=['ApproximateNumberOfMessages'])
        count = queue['Attributes']['ApproximateNumberOfMessages']
        return {'Success': True, 'Count': int(count)}
    except:
        print(traceback.format_exc())
        return {'Success': False, 'Count': 0, 'Exception': traceback.format_exc()}