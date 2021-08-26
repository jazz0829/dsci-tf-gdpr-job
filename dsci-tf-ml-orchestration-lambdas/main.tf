module "lambdas" {
  source                           = "./lambdas"
  bookmark_db_name                 = "${local.bookmark_db_name}"
  bookmark_db_arn                  = "${aws_dynamodb_table.dynamodb_endpoints_bookmark_table.arn}"
  name_prefix                      = "${local.name_prefix}"
  dsci_notifications_sns_topic_arn = "${aws_sns_topic.dsci_notifications_sns_topic.arn}"
  cloudwatch_monitoring_enabled    = "${var.cloudwatch_monitoring_enabled}"
  iteratorage_monitoring_enabled   = "${var.iteratorage_monitoring_enabled}"

  tags = "${var.default_tags}"
}

module "iam" {
  source                                     = "./iam"
  name_prefix                                = "${local.name_prefix}"
  lambda_app_rollback_sagemaker_endpoint_arn = "${module.lambdas.lambda_app_rollback_sagemaker_endpoint_arn}"
  infraops_mgt0_accountid                    = "${var.infraops_mgt0_accountid}"
  infraops_mp00_accountid                    = "${var.infraops_mp00_accountid}"
  tags                                       = "${var.default_tags}"
}
