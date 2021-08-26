resource "aws_cloudwatch_event_rule" "cloudwatch_start_gdpr_job_event_rule" {
  name                = "${var.start_gdpr_job_event_rule_name}"
  schedule_expression = "${var.start_gdpr_job_schedule}"
  description         = "${var.start_gdpr_job_event_rule_description}"
  is_enabled          = "${var.gdpr_job_event_rule_enabled}"
  tags                = "${var.tags}"
}

resource "aws_cloudwatch_event_target" "start_gdpr_job_event_target" {
  target_id = "run-gdpr-job"
  rule      = "${aws_cloudwatch_event_rule.cloudwatch_start_gdpr_job_event_rule.name}"
  arn       = "${var.step_function_arn}"
  role_arn  = "${aws_iam_role.cloudwatch_start_gdpr_job_role.arn}"

  input = "${data.template_file.event_input.rendered}"
}
