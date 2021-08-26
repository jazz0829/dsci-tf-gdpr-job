import boto3
import traceback

def lambda_handler(event, context):
    try:
        ecs_client = boto3.client('ecs')
        response = ecs_client.describe_tasks(
            cluster=event['ClusterArn'],
            tasks=[
                event['TaskArn']
            ]
        )
        return {'Success': True, 'Status': response['tasks'][0]['lastStatus']}
    except:
        print(traceback.format_exc())
        return {'Success': False, 'Exception': traceback.format_exc()}