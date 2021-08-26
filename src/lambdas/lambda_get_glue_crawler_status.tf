module "lambda_get_glue_crawler_status" {
  source                      = "git@github.com:exactsoftware/dsci-tf-modules.git//src/modules/lambda_localfile?ref=v0.0.19"
  app_name                    = "${local.get_glue_crawler_status_lambda_function_name}"
  description                 = "Lambda function to get a specific glue crawler's Status"
  iam_policy_document         = "${data.aws_iam_policy_document.get_glue_crawler_status_lambda_iam_policy_document.json}"
  assume_role_policy_document = "${data.aws_iam_policy_document.lambda_assume_role.json}"
  lambda_filename             = "${data.archive_file.get_glue_crawler_status_lambda_archive_file.0.output_path}"
  lambda_source_code_hash     = "${data.archive_file.get_glue_crawler_status_lambda_archive_file.0.output_base64sha256}"
  handler                     = "${var.handler}"
  runtime                     = "${var.runtime}"

  environment_variables = {
    FOO = "BAR"
  }

  alarm_action_arn               = ""
  monitoring_enabled             = 0
  iteratorage_monitoring_enabled = false
  timeout                        = "${var.lambda_default_timeout}"
  tags                           = "${var.default_tags}"
}

data "null_data_source" "get_glue_crawler_status_lambda_file" {
  inputs {
    filename = "${substr("${path.module}/functions/get-glue-crawler-status/handler.py", length(path.cwd) + 1, -1)}"
  }
}

data "null_data_source" "get_glue_crawler_status_archive" {
  inputs {
    filename = "${substr("${path.module}/functions/get-glue-crawler-status/cig-get-glue-crawler-status.zip", length(path.cwd) + 1, -1)}"
  }
}

data "archive_file" "get_glue_crawler_status_lambda_archive_file" {
  type        = "zip"
  source_file = "${data.null_data_source.get_glue_crawler_status_lambda_file.outputs.filename}"
  output_path = "${data.null_data_source.get_glue_crawler_status_archive.outputs.filename}"
}
