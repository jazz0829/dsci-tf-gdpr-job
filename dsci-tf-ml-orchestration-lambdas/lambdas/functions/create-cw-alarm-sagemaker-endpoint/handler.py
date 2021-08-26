import boto3
import os

cloudwatch = boto3.client('cloudwatch')
sagemaker_client = boto3.client('sagemaker')
ALARM_ACTION = os.environ['ERROR_TOPIC']
OK_ACTION = os.environ['INFO_TOPIC']


def lambda_handler(event, context):
    endpoint_name = event['name']
    production_variants = sagemaker_client.describe_endpoint(EndpointName=endpoint_name)['ProductionVariants']
    for variant in production_variants:
        alarm_400_name = endpoint_name + '_' + variant['VariantName'] + '_4xxErrors'
        alarm_500_name = endpoint_name + '_' + variant['VariantName'] + '_5xxErrors'
        if not metric_alarm_exists(alarm_400_name):
            create_sagemaker_cloudwatch_alarm(alarm_400_name, endpoint_name, variant, 'Invocation4XXErrors')

        if not metric_alarm_exists(alarm_500_name):
            create_sagemaker_cloudwatch_alarm(alarm_500_name, endpoint_name, variant, 'Invocation5XXErrors')
    return {'status': 'alarms_created'}


def create_sagemaker_cloudwatch_alarm(alarm_name, endpoint_name, variant, metric_name):
    cloudwatch.put_metric_alarm(
        AlarmName=alarm_name,
        ComparisonOperator='GreaterThanThreshold',
        EvaluationPeriods=1,
        MetricName=metric_name,
        Namespace='AWS/Sagemaker',
        Period=60,
        Statistic='Sum',
        Threshold=0.0,
        ActionsEnabled=True,
        OKActions=[
            OK_ACTION,
        ],
        AlarmActions=[
            ALARM_ACTION,
        ],
        TreatMissingData='notBreaching',
        AlarmDescription='Alarm when 4xx/5xx errors occur on sagemaker endpoint' + endpoint_name,
        Dimensions=[
            {
                'Name': 'EndpointName',
                'Value': endpoint_name,
            },
            {
                'Name': 'VariantName',
                'Value': variant['VariantName']

            }
        ],
        Unit='Seconds'
    )


def metric_alarm_exists(name):
    response = cloudwatch.describe_alarms(AlarmNames=[name])
    if len(response['MetricAlarms']) > 0:
        return True
    else:
        return False
