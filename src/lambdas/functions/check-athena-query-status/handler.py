import boto3
import traceback

def lambda_handler(event, context):
    try:
        athena_client = boto3.client('athena', region_name='eu-west-1')
        s3_client = boto3.client('s3', region_name='eu-west-1')
        query_execution_ids = event['QueryExecutionIds']
        result_output_locations = []
        all_queries_finished = True
        for query_execution_id in query_execution_ids:

            response = athena_client.get_query_execution(QueryExecutionId=query_execution_id)
            status = response['QueryExecution']['Status']['State']
            if status == 'SUCCEEDED':
                output_location = response['QueryExecution']['ResultConfiguration']['OutputLocation']
                path_parts = output_location.replace("s3://","").split("/")
                bucket_name = path_parts.pop(0)
                key = '/'.join(path_parts)
                response = s3_client.select_object_content(
                    Bucket=bucket_name,
                    Key=key,
                    ExpressionType='SQL',
                    Expression="Select count(0) from S3Object s",
                    InputSerialization={
                        'CSV': {
                            'FileHeaderInfo': 'USE',
                            'RecordDelimiter': '\n',
                            'FieldDelimiter': ',',
                            'AllowQuotedRecordDelimiter': True
                        }
                    },
                    OutputSerialization={
                        'CSV': {
                        }
                    }
                )

                for event in response['Payload']:
                    if 'Records' in event:
                        count = event['Records']['Payload'].decode('utf-8').rstrip('\n')
                        if int(count) > 0:
                            result_output_locations.append(output_location)

            elif status == 'QUEUED' or status == 'RUNNING':
                all_queries_finished = False
                break

            else:
                #TODO: handles when queries has failed or cancelled
                pass

        return {'Success': True, 'AllQueriesFinished': all_queries_finished, 'OutputLocations': result_output_locations}

    except:
        return {'Success': False, 'Exception': traceback.format_exc()}