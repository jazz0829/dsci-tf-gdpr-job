import boto3
import traceback

def lambda_handler(event, context):
    try:
        ecs_client = boto3.client('ecs')
        params = event['inputs']['send_to_be_altered_files_s3_keys_to_sqs']

        file_paths = []
        for output_location in event['results']['athena_query_status']['OutputLocations']:
            file_paths.append(output_location)

        for item in params['overrides']['containerOverrides'][0]['environment']:
            print(item)
            if item['name'] == f'FILE_PATHS':
                seperator = ','
                item['value'] = seperator.join(file_paths)

        print(params)
        response = ecs_client.run_task(**params)
        cluster_arn = response['tasks'][0]['clusterArn']
        task_arn = response['tasks'][0]['taskArn']

        return {'Success': True, 'ClusterArn': cluster_arn, 'TaskArn': task_arn}
    except:
        print(traceback.format_exc())
        return {'Success': False, 'Exception': traceback.format_exc()}