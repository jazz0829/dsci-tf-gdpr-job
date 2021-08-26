import boto3
from time import gmtime, strftime


def lambda_handler(event, context):
    sagemaker_client = boto3.client('sagemaker')
    params = event['params']
    params['TrainingJobName'] = params['TrainingJobName'] + \
                                strftime("-%Y-%m-%d-%H-%M-%S", gmtime())

    response = sagemaker_client.create_training_job(**params)

    return {
        'training_job_arn': response['TrainingJobArn']
    }
