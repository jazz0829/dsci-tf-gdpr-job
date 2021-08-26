output "lambda_app_bookmark_sagemaker_endpoint_config_arn" {
  value = "${module.lambda_app_bookmark_sagemaker_endpoint_config.function_arn}"
}

output "lambda_app_create_cloudwatch_alarm_sagemaker_arn" {
  value = "${module.lambda_app_create_cloudwatch_alarm_sagemaker.function_arn}"
}

output "lambda_app_create_sagemaker_endpoint_config_arn" {
  value = "${module.lambda_app_create_sagemaker_endpoint_config.function_arn}"
}

output "lambda_app_create_sagemaker_model_arn" {
  value = "${module.lambda_app_create_sagemaker_model.function_arn}"
}

output "lambda_app_create_sagemaker_training_job_arn" {
  value = "${module.lambda_app_create_sagemaker_training_job.function_arn}"
}

output "lambda_app_get_emr_cluster_status_arn" {
  value = "${module.lambda_app_get_emr_cluster_status.function_arn}"
}

output "lambda_app_get_sagemaker_endpoint_status_arn" {
  value = "${module.lambda_app_get_sagemaker_endpoint_status.function_arn}"
}

output "lambda_app_invoke_sagemaker_endpoint_arn" {
  value = "${module.lambda_app_invoke_sagemaker_endpoint.function_arn}"
}

output "lambda_app_notify_slack_arn" {
  value = "${module.lambda_app_notify_slack.function_arn}"
}

output "lambda_app_notify_slack_function_name" {
  value = "${local.lambda_app_notify_slack}"
}

output "lambda_app_rollback_sagemaker_endpoint_arn" {
  value = "${module.lambda_app_rollback_sagemaker_endpoint.function_arn}"
}

output "lambda_app_run_emr_job_arn" {
  value = "${module.lambda_app_run_emr_job.function_arn}"
}

output "lambda_app_update_sagemaker_endpoint_arn" {
  value = "${module.lambda_app_update_sagemaker_endpoint.function_arn}"
}

output "lambda_app_get_sagemaker_training_job_status_arn" {
  value = "${module.lambda_app_get_sagemaker_training_job_status.function_arn}"
}

output "lambda_app_sagemaker_apply_auto_scaling_arn" {
  value = "${module.lambda_app_sagemaker_apply_auto_scaling.function_arn}"
}

output "lambda_app_sagemaker_apply_auto_scaling_role_arn" {
  value = "${module.lambda_app_sagemaker_apply_auto_scaling.function_role_arn}"
}

output "lambda_update_dynamodb_capacity_arn" {
  value = "${module.lambda_update_dynamodb_capacity.function_arn}"
}
