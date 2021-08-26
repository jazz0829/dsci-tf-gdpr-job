locals {
  name_prefix                  = "${terraform.workspace}"
  bookmark_db_name             = "${local.name_prefix}-${var.bookmark_db}"
  notification_sns_topic_name  = "${local.name_prefix}-dsci-notifications"
  notification_sns_policy_name = "${local.name_prefix}-dsci-notifications-policy"
}
