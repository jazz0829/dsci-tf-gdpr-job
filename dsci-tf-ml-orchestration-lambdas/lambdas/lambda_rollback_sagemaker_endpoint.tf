module "lambda_app_rollback_sagemaker_endpoint" {
  source                      = "../lambda_localfile"
  app_name                    = "${local.lambda_app_rollback_sagemaker_endpoint}"
  description                 = "Lambda function to rollback a sagemaker endpoint to the latest endpoint configuration version from DynamoDB"
  tags                        = "${var.tags}"
  iam_policy_document         = "${data.aws_iam_policy_document.rollback_sagemaker_endpoint_lambda_iam_role.json}"
  assume_role_policy_document = "${data.aws_iam_policy_document.lambda_assume_role.json}"
  lambda_filename             = "${data.archive_file.rollback_sagemaker_endpoint_lambda_archive_file.0.output_path}"
  lambda_source_code_hash     = "${data.archive_file.rollback_sagemaker_endpoint_lambda_archive_file.0.output_base64sha256}"
  handler                     = "${var.handler}"
  runtime                     = "${var.runtime}"
  name_prefix                 = "${var.name_prefix}"

  environment_variables = {
    BOOKMARK_TABLE = "${var.bookmark_db_name}"
  }

  alarm_action_arn               = "${var.dsci_notifications_sns_topic_arn}"
  ok_action_arn                  = "${var.dsci_notifications_sns_topic_arn}"
  monitoring_enabled             = "${var.cloudwatch_monitoring_enabled}"
  iteratorage_monitoring_enabled = "${var.iteratorage_monitoring_enabled}"
  timeout                        = "${var.lambda_timeout}"
}

data "null_data_source" "rollback_sagemaker_endpoint_lambda_file" {
  inputs {
    filename = "${substr("${path.module}/functions/rollback-sagemaker-endpoint/handler.py", length(path.cwd) + 1, -1)}"
  }
}

data "null_data_source" "rollback_sagemaker_endpoint_lambda_archive" {
  inputs {
    filename = "${substr("${path.module}/functions/rollback-sagemaker-endpoint/dsci-sagemaker-rollback-endpoint.zip", length(path.cwd) + 1, -1)}"
  }
}

data "archive_file" "rollback_sagemaker_endpoint_lambda_archive_file" {
  type        = "zip"
  source_file = "${data.null_data_source.rollback_sagemaker_endpoint_lambda_file.outputs.filename}"
  output_path = "${data.null_data_source.rollback_sagemaker_endpoint_lambda_archive.outputs.filename}"
}
