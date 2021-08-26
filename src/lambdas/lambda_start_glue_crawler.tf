module "lambda_start_glue_crawler" {
  source                      = "git@github.com:exactsoftware/dsci-tf-modules.git//src/modules/lambda_localfile?ref=v0.0.19"
  app_name                    = "${local.start_glue_crawler_lambda_function_name}"
  description                 = "Lambda function to start a specific glue crawler"
  iam_policy_document         = "${data.aws_iam_policy_document.start_glue_crawler_lambda_iam_policy_document.json}"
  assume_role_policy_document = "${data.aws_iam_policy_document.lambda_assume_role.json}"
  lambda_filename             = "${data.archive_file.start_glue_crawler_lambda_archive_file.0.output_path}"
  lambda_source_code_hash     = "${data.archive_file.start_glue_crawler_lambda_archive_file.0.output_base64sha256}"
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

data "null_data_source" "start_glue_crawler_lambda_file" {
  inputs {
    filename = "${substr("${path.module}/functions/start-glue-crawler/handler.py", length(path.cwd) + 1, -1)}"
  }
}

data "null_data_source" "start_glue_crawler_archive" {
  inputs {
    filename = "${substr("${path.module}/functions/start-glue-crawler/cig-start-glue-crawler.zip", length(path.cwd) + 1, -1)}"
  }
}

data "archive_file" "start_glue_crawler_lambda_archive_file" {
  type        = "zip"
  source_file = "${data.null_data_source.start_glue_crawler_lambda_file.outputs.filename}"
  output_path = "${data.null_data_source.start_glue_crawler_archive.outputs.filename}"
}
