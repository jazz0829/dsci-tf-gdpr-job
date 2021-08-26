import boto3
import traceback

def lambda_handler(event, context):
    try:
        dynamodb_client = boto3.client('dynamodb')
        tables = event['tables']
        for table in tables:
            try:
                table_name = table['TableName']
                response = dynamodb_client.describe_table(TableName = table_name)
                read_capacity_units = response['Table']['ProvisionedThroughput']['ReadCapacityUnits']
                write_capacity_units = response['Table']['ProvisionedThroughput']['WriteCapacityUnits']

                if 'WriteCapacityUnits' in table and 'ReadCapacityUnits' in table:
                    if int(table['WriteCapacityUnits']) == write_capacity_units and int(table['ReadCapacityUnits']) ==  read_capacity_units :
                        return { 'Success' : False , 'Message': f'Cannot update the table {table_name} because the provided desired WriteCapacityUnits and ReadCapacityUnits are equal to the current capacity set for this table'}
                    else:
                        provisioned_throughput = {
                            'WriteCapacityUnits':int(table['WriteCapacityUnits']),
                            'ReadCapacityUnits': int(table['ReadCapacityUnits'])
                        }
                elif 'WriteCapacityUnits' in table and not 'ReadCapacityUnits' in table:
                    provisioned_throughput = {
                        'WriteCapacityUnits':int(table['WriteCapacityUnits']),
                        'ReadCapacityUnits': read_capacity_units
                    }
                elif 'ReadCapacityUnits' in table and not 'WriteCapacityUnits' in table:
                    provisioned_throughput = {
                        'WriteCapacityUnits':write_capacity_units,
                        'ReadCapacityUnits':int(table['ReadCapacityUnits'])
                    }
                else:
                    return { 'Success' : False , 'Message': f'Please provide required arguments: WriteCapacityUnits or ReadCapacityUnits or both'}

                dynamodb_client.update_table(
                    TableName=table_name,
                    ProvisionedThroughput=provisioned_throughput
                )
            except dynamodb_client.exceptions.ResourceNotFoundException:
                return { 'Success' : False , 'Message': f'Cannot find any dynamodb table with the name: {table_name}', 'Exception': traceback.format_exc()}
            except dynamodb_client.exceptions.ResourceInUseException:
                return { 'Success' : False , 'Message': f'Cannot update the table: {table_name} because it is still being updated', 'Exception': traceback.format_exc()}

        return { 'Success': True}
    except:
        print(traceback.format_exc())
        return { 'Success' : False , 'Exception': traceback.format_exc()}