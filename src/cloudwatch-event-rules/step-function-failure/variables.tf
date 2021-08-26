variable "failure_description" {
  default = "Cloudwatch event rule to detect failure of the GDPR step function"
}

variable "cloudwatch_metric_alarm_threshold" {
  default = 0
}

variable "cloudwatch_metric_alarm_period" {
  default = 60
}

variable "cloudwatch_metric_alarm_evaluation_periods" {
  default = 1
}

variable "step_function_name" {}
variable "step_function_arn" {}
variable "notification_topic_arn" {}
