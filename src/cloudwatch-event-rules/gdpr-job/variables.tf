variable "start_gdpr_job_event_rule_name" {}

variable "start_gdpr_job_schedule" {
  default = "cron(0 2 1 * ? *)"
}

variable "start_gdpr_job_event_rule_description" {
  default = "Cloudwatch event rule to schedule the GDPR job to anonymize EOL data "
}

variable "start_gdpr_job_event_input_file" {
  default = "cloudwatch-event-rules/gdpr-job/input.json"
}

variable "start_gdpr_job_role_name" {
  default = "gdpr-job-allow-start-execution"
}

variable "tags" {
  type = "map"
}

variable "low_write_capacity_units" {
  default = 1
}

variable "high_write_capacity_units" {
  default = 200
}

variable "high_read_capacity_units" {
  default = 10
}

variable "low_read_capacity_units" {
  default = 1
}

variable "emr_master_node_instance_type" {
  default = "m4.large"
}

variable "emr_master_node_instance_count" {
  default = 1
}

variable "emr_core_node_instance_type" {
  default = "m4.xlarge"
}

variable "emr_core_node_instance_count" {
  default = 1
}

variable "eol_data_crawler_name" {}
variable "name_prefix" {}
variable "step_function_name" {}
variable "step_function_arn" {}
variable "accountid" {}
variable "eol_database_name" {}
variable "gdpr_job_event_rule_enabled" {}
variable "fargate_cluster_arn" {}
variable "task_definition_arn" {}
variable "sqs_queue_name" {}
variable "emr_sqs_queue_name" {}
variable "cig_gdpr_log_dynamodb_table_name" {}
variable "cig_database_name" {}
variable "emr_install_dependencies_script_s3_key" {}
variable "cig_gdpr_bucket_name" {}
variable "process_gdpr_requests_script_s3_key" {}
variable "ecs_subnet_id" {}
variable "emr_subnet_id" {}