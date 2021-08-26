output "query_data_lake_for_gdpr_requests_lambda_function_arn" {
  value = "${module.lambda_query_data_lake_for_gdpr_requests.lambda_arn}"
}

output "check_athena_query_status_lambda_function_arn" {
  value = "${module.lambda_check_athena_query_status.lambda_arn}"
}

output "process_gdpr_requests_lambda_function_arn" {
  value = "${module.lambda_process_gdpr_requests.lambda_arn}"
}

output "get_sqs_queue_messages_count_lambda_function_arn" {
  value = "${module.lambda_get_sqs_queue_messages_count.lambda_arn}"
}

output "start_glue_crawler_lambda_function_arn" {
  value = "${module.lambda_start_glue_crawler.lambda_arn}"
}

output "get_glue_crawler_status_lambda_function_arn" {
  value = "${module.lambda_get_glue_crawler_status.lambda_arn}"
}

output "run_ecs_task_lambda_function_arn" {
  value = "${module.lambda_run_ecs_task.lambda_arn}"
}

output "check_ecs_task_status_lambda_function_arn" {
  value = "${module.lambda_check_ecs_task_status.lambda_arn}"
}
