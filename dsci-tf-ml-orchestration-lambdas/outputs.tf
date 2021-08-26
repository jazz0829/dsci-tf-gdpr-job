output "dynamodb_endpoints_bookmark_table" {
  value = "${aws_dynamodb_table.dynamodb_endpoints_bookmark_table.name}"
}

output "dsci_notifications_sns_topic_arn" {
  value = "${aws_sns_topic.dsci_notifications_sns_topic.arn}"
}

output "lambda_app_bookmark_sagemaker_endpoint_config_arn" {
  value = "${module.lambdas.lambda_app_bookmark_sagemaker_endpoint_config_arn}"
}

output "lambda_app_create_cloudwatch_alarm_sagemaker_arn" {
  value = "${module.lambdas.lambda_app_create_cloudwatch_alarm_sagemaker_arn}"
}

output "lambda_app_create_sagemaker_endpoint_config_arn" {
  value = "${module.lambdas.lambda_app_create_sagemaker_endpoint_config_arn}"
}

output "lambda_app_create_sagemaker_model_arn" {
  value = "${module.lambdas.lambda_app_create_sagemaker_model_arn}"
}

output "lambda_app_create_sagemaker_training_job_arn" {
  value = "${module.lambdas.lambda_app_create_sagemaker_training_job_arn}"
}

output "lambda_app_get_emr_cluster_status_arn" {
  value = "${module.lambdas.lambda_app_get_emr_cluster_status_arn}"
}

output "lambda_app_get_sagemaker_endpoint_status_arn" {
  value = "${module.lambdas.lambda_app_get_sagemaker_endpoint_status_arn}"
}

output "lambda_app_invoke_sagemaker_endpoint_arn" {
  value = "${module.lambdas.lambda_app_invoke_sagemaker_endpoint_arn}"
}

output "lambda_app_notify_slack_arn" {
  value = "${module.lambdas.lambda_app_notify_slack_arn}"
}

output "lambda_app_notify_slack_function_name" {
  value = "${module.lambdas.lambda_app_notify_slack_function_name}"
}

output "lambda_app_rollback_sagemaker_endpoint_arn" {
  value = "${module.lambdas.lambda_app_rollback_sagemaker_endpoint_arn}"
}

output "lambda_app_run_emr_job_arn" {
  value = "${module.lambdas.lambda_app_run_emr_job_arn}"
}

output "lambda_app_update_sagemaker_endpoint_arn" {
  value = "${module.lambdas.lambda_app_update_sagemaker_endpoint_arn}"
}

output "lambda_app_get_sagemaker_training_status_output" {
  value = "${module.lambdas.lambda_app_get_sagemaker_training_job_status_arn}"
}

output "lambda_app_sagemaker_apply_auto_scaling_arn" {
  value = "${module.lambdas.lambda_app_sagemaker_apply_auto_scaling_arn}"
}

output "lambda_update_dynamodb_capacity_arn" {
  value = "${module.lambdas.lambda_update_dynamodb_capacity_arn}"
}

## IAM ##

output "crossaccount_access_infraops_arn" {
  value = "${module.iam.crossaccount_access_infraops_arn}"
}

output "crossaccount_access_infraops_id" {
  value = "${module.iam.crossaccount_access_infraops_id}"
}

output "lambda_app_sagemaker_apply_auto_scaling_role_arn" {
  value = "${module.lambdas.lambda_app_sagemaker_apply_auto_scaling_role_arn}"
}
