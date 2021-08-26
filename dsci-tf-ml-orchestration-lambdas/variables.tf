variable "region" {}

variable "accountid" {}

variable "description" {
  default = "Lambda function that checks the status of a sagemaker batch transform job"
}

variable "bookmark_db" {
  default = "dsci-sm-endpoint-last-updated"
}

variable "default_tags" {
  description = "Map of tags to add to all resources"
  type        = "map"

  default = {
    Terraform   = "true"
    GitHub-Repo = "exactsoftware/dsci-tf-ml-orchestration-lambdas"
  }
}

variable "cloudwatch_monitoring_enabled" {
  default = 0
}

variable "iteratorage_monitoring_enabled" {
  default = false
}

variable "infraops_mgt0_accountid" {
  description = "Account ID of MGT0"
  default     = "984021659265"
}

variable "infraops_mp00_accountid" {
  description = "Account ID MP00"
  default     = "620077473225"
}
