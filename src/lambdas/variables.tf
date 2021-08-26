variable "handler" {
  default = "handler.lambda_handler"
}

variable "runtime" {
  default = "python3.7"
}

variable "eol_data_bucket" {
  default = "dsci-exol-data-131239767718-eu-west-1"
}

variable "dsci_eol_domain_data_bucket" {
  default = "dsci-eol-data-bucket"
}

variable "accountid" {}
variable "name_prefix" {}
variable "gdpr_requests_sqs_queue_arn" {}
variable "gdpr_requests_sqs_queue_name" {}
variable "gdpr_log_table_name" {}
variable "gdpr_log_dynamodb_arn" {}

variable "lambda_default_timeout" {
  default = 240
}

variable "gdpr_request_batch_size" {
  default = 1
}

variable "default_tags" {
  type = "map"
}

variable "memory_size" {
  default = 256
}

variable "max_lambda_memory_size" {
  default = 512
}

variable "reserved_concurrent_executions" {
  default = 800
}

variable "environment" {}
variable "region" {}
