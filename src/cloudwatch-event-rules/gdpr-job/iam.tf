resource "aws_iam_role" "cloudwatch_start_gdpr_job_role" {
  name               = "${local.start_gdpr_job_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.cloudwatch_assume_role_policy_document.json}"
  tags               = "${var.tags}"
}

resource "aws_iam_role_policy" "cloudwatch_start_gdpr_job_policy" {
  name   = "${local.start_gdpr_job_role_name}"
  role   = "${aws_iam_role.cloudwatch_start_gdpr_job_role.id}"
  policy = "${data.aws_iam_policy_document.cloudwatch_start_execution_policy_document.json}"
}
