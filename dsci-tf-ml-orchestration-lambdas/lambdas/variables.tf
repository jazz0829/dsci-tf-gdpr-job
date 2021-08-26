variable "name_prefix" {}

variable "handler" {
  default = "handler.lambda_handler"
}

variable "runtime" {
  default = "python3.7"
}

variable "lambda_timeout" {
  default = 60
}

variable "bookmark_db_name" {}

variable "bookmark_db_arn" {}

variable "tags" {
  type = "map"
}

variable "dsci_notifications_sns_topic_arn" {}

variable "cloudwatch_monitoring_enabled" {}

variable "iteratorage_monitoring_enabled" {}
