data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "query_data_lake_for_gdpr_requests_lambda_iam_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "athena:StartQueryExecution",
      "athena:GetQueryExecution",
      "glue:GetPartitions",
      "glue:GetDatabase",
      "iam:PassRole",
      "glue:GetTable",
      "s3:ListBucket",
    ]

    resources = [
      "*",
    ]
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
      "s3:PutObject",
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
    ]

    resources = [
      "arn:aws:s3:::${var.eol_data_bucket}",
      "arn:aws:s3:::${var.eol_data_bucket}/*",
      "arn:aws:s3:::cig-${var.environment}-domain-bucket",
      "arn:aws:s3:::cig-${var.environment}-domain-bucket/*",
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

data "aws_iam_policy_document" "check_athena_query_status_lambda_iam_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "athena:GetQueryExecution",
      "iam:PassRole",
    ]

    resources = [
      "*",
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
}

data "aws_iam_policy_document" "send_gdpr_requests_to_sqs_lambda_iam_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueUrl",
      "iam:PassRole",
    ]

    resources = ["${var.gdpr_requests_sqs_queue_arn}"]
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
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

data "aws_iam_policy_document" "process_gdpr_requests_lambda_iam_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "iam:PassRole",
    ]

    resources = ["${var.gdpr_requests_sqs_queue_arn}"]
  }

  statement {
    effect = "Allow"

    actions = [
      "dynamodb:PutItem",
      "iam:PassRole",
    ]

    resources = ["${var.gdpr_log_dynamodb_arn}"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:DeleteObject",
      "s3:DeleteObjectTagging",
      "s3:DeleteObjectVersion",
      "s3:DeleteObjectVersionTagging"
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

data "aws_iam_policy_document" "get_sqs_queue_messages_count_lambda_iam_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "iam:PassRole",
    ]

    resources = ["${var.gdpr_requests_sqs_queue_arn}"]
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

data "aws_iam_policy_document" "start_glue_crawler_lambda_iam_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "glue:StartCrawler",
      "iam:PassRole",
    ]

    resources = ["arn:aws:glue:${var.region}:${var.accountid}:crawler/*"]
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

data "aws_iam_policy_document" "get_glue_crawler_status_lambda_iam_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "glue:GetCrawler",
      "iam:PassRole",
    ]

    resources = ["arn:aws:glue:${var.region}:${var.accountid}:crawler/*"]
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

data "aws_iam_policy_document" "run_ecs_task_lambda_iam_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "ecs:RunTask",
      "iam:PassRole",
    ]

    resources = ["*"]
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

data "aws_iam_policy_document" "check_ecs_task_status_lambda_iam_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "ecs:DescribeTasks",
      "iam:PassRole",
    ]

    resources = ["*"]
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
