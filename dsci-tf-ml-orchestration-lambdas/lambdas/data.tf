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

data "aws_iam_policy_document" "create_training_job_lambda_iam_role" {
  statement {
    effect = "Allow"

    actions = [
      "sagemaker:CreateTrainingJob",
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
}

data "aws_iam_policy_document" "update_sagemaker_endpoint_lambda_iam_role" {
  statement {
    effect = "Allow"

    actions = [
      "sagemaker:DescribeEndpoint",
      "sagemaker:CreateEndpoint",
      "sagemaker:UpdateEndpoint",
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
}

data "aws_iam_policy_document" "create_sagemaker_endpoint_config_lambda_iam_role" {
  statement {
    effect = "Allow"

    actions = [
      "sagemaker:CreateEndpointConfig",
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
}

data "aws_iam_policy_document" "get_sagemaker_endpoint_status_lambda_iam_role" {
  statement {
    effect = "Allow"

    actions = [
      "sagemaker:DescribeEndpoint",
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
}

data "aws_iam_policy_document" "create_sagemaker_alarms_cloudwatch_lambda_iam_role" {
  statement {
    effect = "Allow"

    actions = [
      "sagemaker:DescribeEndpoint",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
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
}

data "aws_iam_policy_document" "create_sagemaker_training_job_lambda_iam_role" {
  statement {
    effect = "Allow"

    actions = [
      "sagemaker:CreateTrainingJob",
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
}

data "aws_iam_policy_document" "invoke_sagemaker_endpoint_lambda_iam_role" {
  statement {
    effect = "Allow"

    actions = [
      "sagemaker:InvokeEndpoint",
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
}

data "aws_iam_policy_document" "sagemaker_bookmark_endpoint_config_lambda_iam_role" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:PutItem",
      "sagemaker:DescribeEndpoint",
      "iam:PassRole",
    ]

    resources = [
      "${var.bookmark_db_arn}",
      "arn:aws:sagemaker:*:*:*",
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

data "aws_iam_policy_document" "rollback_sagemaker_endpoint_lambda_iam_role" {
  statement {
    effect = "Allow"

    actions = [
      "sagemaker:DescribeEndpoint",
      "sagemaker:UpdateEndpoint",
      "dynamodb:GetItem",
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
}

data "aws_iam_policy_document" "create_sagemaker_model_lambda_iam_role" {
  statement {
    effect = "Allow"

    actions = [
      "sagemaker:CreateModel",
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
}

data "aws_iam_policy_document" "run_emr_job_lambda_iam_role" {
  statement {
    effect = "Allow"

    actions = [
      "elasticmapreduce:RunJobFlow",
      "iam:PassRole",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      "arn:aws:s3:::*",
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

data "aws_iam_policy_document" "get_emr_cluster_status_lambda_iam_role" {
  statement {
    effect = "Allow"

    actions = [
      "elasticmapreduce:DescribeCluster",
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
}

data "aws_iam_policy_document" "notify_slack_lambda_iam_role" {
  statement {
    effect = "Allow"

    actions = [
      "kms:Decrypt",
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
}

data "aws_iam_policy_document" "training_job_status_lambda_iam_role" {
  statement {
    effect = "Allow"

    actions = [
      "sagemaker:DescribeTrainingJob",
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
}

data "aws_iam_policy_document" "apply_auto_scaling_policy_lambda_iam_role" {
  statement {
    effect = "Allow"

    actions = [
      "iam:PassRole",
      "iam:CreateServiceLinkedRole",
      "application-autoscaling:RegisterScalableTarget",
      "application-autoscaling:PutScalingPolicy",
      "sagemaker:DescribeEndpoint",
      "sagemaker:DescribeEndpointConfig",
      "sagemaker:UpdateEndpointWeightsAndCapacities",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
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
}

data "aws_iam_policy_document" "update_dynamodb_capacity_lambda_iam_role" {
  statement {
    effect = "Allow"

    actions = [
      "iam:PassRole",
      "dynamodb:UpdateTable",
      "dynamodb:DescribeTable",
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
}
