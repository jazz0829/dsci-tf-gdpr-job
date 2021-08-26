module "lambda_process_gdpr_requests" {
  source                         = "git@github.com:exactsoftware/dsci-tf-modules.git//src/modules/lambda_python_dependencies?ref=v0.0.19"
  app_name                       = "${local.process_gdpr_requests_lambda_function_name}"
  description                    = "Lambda function to process gdpr requests (file:[id_to_be_deleted]) from the GDPR SQS queue"
  iam_policy_document            = "${data.aws_iam_policy_document.process_gdpr_requests_lambda_iam_policy_document.json}"
  assume_role_policy_document    = "${data.aws_iam_policy_document.lambda_assume_role.json}"
  handler                        = "${var.handler}"
  runtime                        = "${var.runtime}"
  source_path                    = "${path.module}/functions/process-gdpr-requests/"
  reserved_concurrent_executions = "${var.reserved_concurrent_executions}"
  memory_size                    = "${var.max_lambda_memory_size}"

  environment_variables = {
    GDPR_QUEUE_NAME     = "${var.gdpr_requests_sqs_queue_name}"
    GDPR_LOG_TABLE_NAME = "${var.gdpr_log_table_name}"
  }

  alarm_action_arn               = ""
  monitoring_enabled             = 0
  iteratorage_monitoring_enabled = false
  timeout                        = 900
  tags                           = "${var.default_tags}"
}

resource "aws_lambda_event_source_mapping" "process_gdpr_requests_lambda_sqs_mapping" {
  event_source_arn = "${var.gdpr_requests_sqs_queue_arn}"
  function_name    = "${module.lambda_process_gdpr_requests.lambda_name}"
  batch_size       = "${var.gdpr_request_batch_size}"
  enabled          = true
}
