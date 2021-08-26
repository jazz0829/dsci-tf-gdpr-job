import boto3
import traceback
from datetime import date, timedelta

max_date = date.today() - timedelta(days=150)
sub_query_account = f"sub_query_account as (SELECT UPPER(ID) FROM customerintelligence_raw.object_host_cig_accounts WHERE isanonymized = '1')"
sub_query_division = f"sub_query_division as (SELECT cast(d.divisioncode as VARCHAR) FROM customerintelligence.accountscontract_summary a JOIN customerintelligence.divisions d ON d.accountid =" \
    f" a.accountid WHERE maxfinaldate < date '{str(max_date)}' AND a.churned=1 AND a.environment='NL')"
sub_query_select_person = "SELECT UPPER(ID) FROM customerintelligence_raw.object_host_cig_persons WHERE isanonymized = '1'"
sub_query_person = f"sub_query_person as ({sub_query_select_person})"
sub_query_user = f"sub_query_user as (SELECT UPPER(ID) FROM customerintelligence_raw.object_host_cig_users where UPPER(person) in ({sub_query_select_person}))"

def lambda_handler(event, context):
    try:
        athena_client = boto3.client('athena', region_name='eu-west-1')

        responses = []
        for query in event['queries']:
            if query['Action'] == 'Delete':
                athena_query = get_query_for_deletion(query)
            elif query['Action'] == 'Anonymize':
                athena_query = get_query_for_anonymisation(query)

            query_settings = query['QuerySettings']
            query_settings['QueryString'] = athena_query
            response = execute_athena_query(athena_client,query_settings)
            if response:
                responses.append(response['QueryExecutionId'])

        return {
            'Success': True, 'QueryExecutionIds': responses
        }
    except:
        return {'Success': False, 'Exception': traceback.format_exc()}

def execute_athena_query(athena_client, query_setting):
    try:
        return athena_client.start_query_execution(**query_setting)
    except:
        print(traceback.format_exc())

def get_query_for_anonymisation(query_object):
    queries = []
    sub_queries_targets = set()
    for table in query_object['Tables']:
        anonymized_columns = ','.join(table['AnonymizeColumns'])
        anonymized_fields_filters = list(map(lambda c: c + " != '####'",table['AnonymizeColumns']))
        anonymized_fields_filter_clause = " and ".join(anonymized_fields_filters)
        queries.append(f'select distinct {table["KeyColumn"]} as "id_to_be_anonymized", "$path" as Path,'
                f"'{table['KeyColumn']}' as table_key, "
                f"'{anonymized_columns}' as anonymize_columns "
                f'from {table["Name"]} '
                f'where {table["KeyColumn"]} in (select * from {table["SubQuery"]}) '
                f'and {anonymized_fields_filter_clause}')
        sub_queries_targets.add(table['SubQuery'])

    sub_query = get_sub_queries(sub_queries_targets)

    return sub_query +(' union '.join(queries))

def get_query_for_deletion(query_object):
    if query_object['KeepLatest']:
        return get_query_for_old_records_deletion(query_object)
    else:
        return get_query_for_all_records_deletion(query_object)

def get_query_for_old_records_deletion(query_object):
    keep_latest_queries = []
    sub_query_targets = set()
    for table in query_object['Tables']:
        keep_latest_queries.append(f'SELECT DISTINCT {table["KeyColumn"]} AS id_to_be_deleted, "$path" AS Path,'
            f"'{table['KeyColumn']}' AS table_key, "
            f'ROW_NUMBER() OVER (Partition BY ID ORDER BY {table["DateColumn"]} desc) AS RowNumber '
            f'FROM {table["Name"]} WHERE UPPER({table["KeyColumn"]}) IN (SELECT * FROM {table["SubQuery"]})')
        sub_query_targets.add(table['SubQuery'])

    keep_latest_query = f'SELECT id_to_be_deleted, Path, table_key FROM (' + (' union '.join(keep_latest_queries)) + ') WHERE RowNumber > 1'
    sub_queries = get_sub_queries(sub_query_targets)

    return sub_queries + keep_latest_query

def get_query_for_all_records_deletion(query_object):
    delete_all_queries = []
    sub_query_targets = set()
    for table in query_object['Tables']:
        delete_all_queries.append(f'SELECT DISTINCT {table["KeyColumn"]} AS "id_to_be_deleted", "$path" AS Path, '
            f"'{table['KeyColumn']}' AS table_key "
            f'FROM {table["Name"]} WHERE UPPER({table["KeyColumn"]}) IN (select * FROM {table["SubQuery"]})')
        sub_query_targets.add(table["SubQuery"])

    delete_all_query = f'SELECT id_to_be_deleted, Path, table_key FROM (' + (' union '.join(delete_all_queries)) + ')'
    sub_queries = get_sub_queries(sub_query_targets)

    return sub_queries + delete_all_query

def get_sub_queries(sub_queries_targets):
    sub_queries = set()
    for sub_query_target in sub_queries_targets:
        if sub_query_target == 'sub_query_account':
            sub_queries.add(sub_query_account)
        elif sub_query_target == 'sub_query_division':
            sub_queries.add(sub_query_division)
        elif sub_query_target == 'sub_query_person':
            sub_queries.add(sub_query_person)
        elif sub_query_target == 'sub_query_user':
            sub_queries.add(sub_query_user)

    return 'WITH '+ ','.join(sub_queries)