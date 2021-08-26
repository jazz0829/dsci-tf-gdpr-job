import boto3
import traceback

def lambda_handler(event, context):
    try:
        if 'IsEnabled' in event and event['IsEnabled']:
            client = boto3.client('application-autoscaling')

            client.register_scalable_target(
                ServiceNamespace='sagemaker',
                ResourceId='endpoint/'+event['EndpointName']+'/variant/'+event['VariantName'],
                ScalableDimension='sagemaker:variant:DesiredInstanceCount',
                MinCapacity=int(event['MinCapacity'],10),
                MaxCapacity=int(event['MaxCapacity'],10),
                RoleARN=event['RoleARN']
            )

            response = client.put_scaling_policy(
                PolicyName='SageMakerEndpointInvocationScalingPolicy',
                ServiceNamespace='sagemaker',
                ResourceId='endpoint/'+event['EndpointName']+'/variant/'+event['VariantName'],
                ScalableDimension='sagemaker:variant:DesiredInstanceCount',
                PolicyType='TargetTrackingScaling',
                TargetTrackingScalingPolicyConfiguration={
                    'TargetValue': 300.0,
                   'PredefinedMetricSpecification': {
                       'PredefinedMetricType': 'SageMakerVariantInvocationsPerInstance'
                   },
                   'ScaleOutCooldown': 60,
                   'ScaleInCooldown': 60,
                   'DisableScaleIn': False
                }
            )
            return {'success': response['ResponseMetadata']['HTTPStatusCode'] == 200}

        return {'success': True, 'message': 'Autoscaling is not enabled for this environment'}
    except:
        print(traceback.format_exc())
        return { 'success' : False , 'exception': traceback.format_exc()}
