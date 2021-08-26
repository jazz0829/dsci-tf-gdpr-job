module "lambda_get_sqs_queue_messages_count" {
  source                      = "git@github.com:exactsoftware/dsci-tf-modules.git//src/modules/lambda_localfile?ref=v0.0.19"
  app_name                    = "${local.get_sqs_queue_messages_count_lambda_function_name}"
  description                 = "Lambda function to get the count of messages in a SQS queue"
  iam_policy_document         = "${data.aws_iam_policy_document.get_sqs_queue_messages_count_lambda_iam_policy_document.json}"
  assume_role_policy_document = "${data.aws_iam_policy_document.lambda_assume_role.json}"
  lambda_filename             = "${data.archive_file.get_sqs_queue_messages_count_lambda_archive_file.0.output_path}"
  lambda_source_code_hash     = "${data.archive_file.get_sqs_queue_messages_count_lambda_archive_file.0.output_base64sha256}"
  handler                     = "${var.handler}"
  runtime                     = "${var.runtime}"

  environment_variables = {
    Foo = "BAR"
  }

  alarm_action_arn               = ""
  monitoring_enabled             = 0
  iteratorage_monitoring_enabled = false
  timeout                        = "${var.lambda_default_timeout}"
  tags                           = "${var.default_tags}"
}

data "null_data_source" "get_sqs_queue_messages_count_lambda_file" {
  inputs {
    filename = "${substr("${path.module}/functions/get-sqs-queue-messages-count/handler.py", length(path.cwd) + 1, -1)}"
  }
}

data "null_data_source" "get_sqs_queue_messages_count_archive" {
  inputs {
    filename = "${substr("${path.module}/functions/get-sqs-queue-messages-count/cig-get-sqs-queue-messages-count.zip", length(path.cwd) + 1, -1)}"
  }
}

data "archive_file" "get_sqs_queue_messages_count_lambda_archive_file" {
  type        = "zip"
  source_file = "${data.null_data_source.get_sqs_queue_messages_count_lambda_file.outputs.filename}"
  output_path = "${data.null_data_source.get_sqs_queue_messages_count_archive.outputs.filename}"
}
