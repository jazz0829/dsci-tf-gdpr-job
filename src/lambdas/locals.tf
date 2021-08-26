locals {
  name_prefix                                                             = "${var.name_prefix}"
  check_ecs_task_status_lambda_function_name                              = "${local.name_prefix}-check-ecs-task-status"
  query_data_lake_for_gdpr_requests_lambda_function_name                  = "${local.name_prefix}-gdpr-query-data-lake-for-anonymization-requests"
  process_gdpr_requests_lambda_function_name                              = "${local.name_prefix}-process-gdpr-requests"
  get_sqs_queue_messages_count_lambda_function_name                       = "${local.name_prefix}-get-sqs-queue-messages-count"
  start_glue_crawler_lambda_function_name                                 = "${local.name_prefix}-start-glue-crawler"
  check_athena_query_status_lambda_function_name                          = "${local.name_prefix}-check-athena-query-status"
  get_glue_crawler_status_lambda_function_name                            = "${local.name_prefix}-get-glue-crawler-status"
  run_ecs_task_lambda_function_name                                       = "${local.name_prefix}-run-ecs-task"
}
