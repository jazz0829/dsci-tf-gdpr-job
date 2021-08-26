resource "aws_cloudwatch_metric_alarm" "step_function_failure_cloudwatch_metric_alarm" {
  alarm_name          = "${var.step_function_name}_execution_failure"
  namespace           = "AWS/States"
  metric_name         = "ExecutionsFailed"
  statistic           = "Sum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "${var.cloudwatch_metric_alarm_threshold}"
  evaluation_periods  = "${var.cloudwatch_metric_alarm_evaluation_periods}"
  period              = "${var.cloudwatch_metric_alarm_period}"
  alarm_description   = "${var.failure_description}"

  alarm_actions      = ["${var.notification_topic_arn}"]
  ok_actions         = ["${var.notification_topic_arn}"]
  treat_missing_data = "notBreaching"

  dimensions {
    StateMachineArn = "${var.step_function_arn}"
  }
}
