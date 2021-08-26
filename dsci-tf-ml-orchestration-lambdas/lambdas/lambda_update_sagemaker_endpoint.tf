module "lambda_app_update_sagemaker_endpoint" {
  source                      = "../lambda_localfile"
  app_name                    = "${local.lambda_app_update_sagemaker_endpoint}"
  description                 = "Lambda function to update a sagemaker endpoint (or create one when it doesn't exist)"
  tags                        = "${var.tags}"
  iam_policy_document         = "${data.aws_iam_policy_document.update_sagemaker_endpoint_lambda_iam_role.json}"
  assume_role_policy_document = "${data.aws_iam_policy_document.lambda_assume_role.json}"
  lambda_filename             = "${data.archive_file.update_sagemaker_endpoint_lambda_archive_file.0.output_path}"
  lambda_source_code_hash     = "${data.archive_file.update_sagemaker_endpoint_lambda_archive_file.0.output_base64sha256}"
  handler                     = "${var.handler}"
  runtime                     = "${var.runtime}"
  name_prefix                 = "${var.name_prefix}"

  environment_variables = {
    FOO = "bar"
  }

  alarm_action_arn               = "${var.dsci_notifications_sns_topic_arn}"
  ok_action_arn                  = "${var.dsci_notifications_sns_topic_arn}"
  monitoring_enabled             = "${var.cloudwatch_monitoring_enabled}"
  iteratorage_monitoring_enabled = "${var.iteratorage_monitoring_enabled}"
  timeout                        = "${var.lambda_timeout}"
}

data "null_data_source" "update_sagemaker_endpoint_lambda_file" {
  inputs {
    filename = "${substr("${path.module}/functions/update-sagemaker-endpoint/handler.py", length(path.cwd) + 1, -1)}"
  }
}

data "null_data_source" "update_sagemaker_endpoint_lambda_archive" {
  inputs {
    filename = "${substr("${path.module}/functions/update-sagemaker-endpoint/dsci-sagemaker-update-sagemaker-endpoint.zip", length(path.cwd) + 1, -1)}"
  }
}

data "archive_file" "update_sagemaker_endpoint_lambda_archive_file" {
  type        = "zip"
  source_file = "${data.null_data_source.update_sagemaker_endpoint_lambda_file.outputs.filename}"
  output_path = "${data.null_data_source.update_sagemaker_endpoint_lambda_archive.outputs.filename}"
}
