resource "aws_iam_role" "crossaccount_access_infraops" {
  name = "${var.name_prefix}-iam-role-infraops"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowAssumeRole",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.infraops_mgt0_accountid}:root",
        "AWS": "arn:aws:iam::${var.infraops_mp00_accountid}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF

  tags = "${var.tags}"
}

resource "aws_iam_policy" "crossaccount_access_infraops_rollback_sagemaker" {
  name = "${var.name_prefix}-iam-policy-infraops-roleback-sagemaker"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction",
                "lambda:InvokeAsync"
            ],
            "Resource": "${var.lambda_app_rollback_sagemaker_endpoint_arn}"
        }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "crossaccount_access_infraops_rollback_sagemaker_attachment" {
  role       = "${aws_iam_role.crossaccount_access_infraops.name}"
  policy_arn = "${aws_iam_policy.crossaccount_access_infraops_rollback_sagemaker.arn}"
}
