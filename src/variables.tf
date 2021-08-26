variable "default_period" {
  default = "60"
}

variable "step_function_definition_file" {
  default = "step-function.json"
}

variable "default_tags" {
  description = "Map of tags to add to all resources"
  type        = "map"

  default = {
    Terraform   = "true"
    GitHub-Repo = "exactsoftware/dsci-tf-gdpr-job"
    Project     = "Data-lake-GDPR"
  }
}

variable "info_topic_name" {
  default = "cig-notifications-info"
}

variable "visibility_timeout_seconds" {
  default = 900
}

variable "eol_crawler_name" {
  default = "cig-eol-data-crawler"
}

variable "eol_database_name" {
  default = "cig-eol-database"
}

variable "cig_database_name" {
  default = "customerintelligence_raw"
}

variable "crawler_raw_s3_target" {
  default = "s3://dsci-exol-data-131239767718-eu-west-1/NL_Customers/"
}

variable "crawler_domain_s3_target" {
  default = "s3://dsci-eol-data-bucket/prod/partitioned/GLTransactions_v2/"
}

variable "crawler_domain_s3_target_2" {
  default = "s3://dsci-eol-data-bucket/prod/partitioned/GLTransactionsMaster/"
}

variable "eol_data_bucket" {
  default = "dsci-exol-data-131239767718-eu-west-1"
}

variable "dsci_eol_domain_data_bucket" {
  default = "dsci-eol-data-bucket"
}

variable "environment" {}
variable "environment_prefix" {}
variable "region" {}
variable "accountid" {}
variable "gdpr_job_event_rule_enabled" {}
variable "ecs_subnet_id" {}
variable "emr_subnet_id" {}
