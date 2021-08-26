data "aws_iam_policy_document" "state_machine_assume_role_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "iam_policy_for_state_machine" {
  name   = "${local.cig_gdpr_state_machine_policy_name}"
  role   = "${aws_iam_role.state_machine_role.id}"
  policy = "${data.aws_iam_policy_document.state_machine_iam_policy_document.json}"
}

data "aws_iam_policy_document" "state_machine_iam_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "lambda:InvokeFunction",
    ]

    resources = [
      "arn:aws:lambda:*:*:function:cig-sagemaker*",
      "${module.lambdas.run_ecs_task_lambda_function_arn}",
      "${module.lambdas.query_data_lake_for_gdpr_requests_lambda_function_arn}",
      "${module.lambdas.check_athena_query_status_lambda_function_arn}",
      "${module.lambdas.get_sqs_queue_messages_count_lambda_function_arn}",
      "${module.lambdas.get_glue_crawler_status_lambda_function_arn}",
      "${module.lambdas.start_glue_crawler_lambda_function_arn}",
      "${data.aws_lambda_function.update_dynamodb_capacity_lambda_function.arn}",
      "${module.lambdas.check_ecs_task_status_lambda_function_arn}",
    ]
  }
}

data "aws_iam_policy_document" "gdpr_ecs_run_task_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "gdpr_ecs_run_task_assume_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueUrl",
      "iam:PassRole",
    ]

    resources = [
      "${aws_sqs_queue.gdpr_requests_queue.arn}",
      "${aws_sqs_queue.gdpr_requests_emr_queue.arn}"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
    ]

    resources = [
      "arn:aws:s3:::aws-athena-query-results-${var.accountid}-eu-west-1/*",
      "arn:aws:s3:::aws-athena-query-results-${var.accountid}-eu-west-1",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.eol_data_bucket}",
      "arn:aws:s3:::${var.eol_data_bucket}/*",
      "arn:aws:s3:::${var.dsci_eol_domain_data_bucket}",
      "arn:aws:s3:::${var.dsci_eol_domain_data_bucket}/*",
      "arn:aws:s3:::cig-${var.environment}-raw-bucket",
      "arn:aws:s3:::cig-${var.environment}-raw-bucket/*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

data "aws_sns_topic" "info_topic" {
  name = "${var.info_topic_name}"
}

data "aws_lambda_function" "notify_slack" {
  function_name = "cig-sagemaker-slack"
}

data "aws_lambda_function" "update_dynamodb_capacity_lambda_function" {
  function_name = "${var.environment_prefix}-dsci-update-dynamodb-capacity"
}

data "aws_lambda_function" "get_emr_cluster_status" {
  function_name = "cig-sagemaker-get-emr-cluster-status"
}

data "aws_lambda_function" "run_emr_job" {
  function_name = "cig-sagemaker-run-emr-job"
}

data "aws_iam_role" "cig_glue_role" {
  name = "cig-glue-role"
}
