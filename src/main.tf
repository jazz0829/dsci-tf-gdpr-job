module "rgs-classification-cloudwatch-event-rule" {
  source                                    = "./cloudwatch-event-rules/gdpr-job"
  start_gdpr_job_event_rule_name            = "${local.cig_start_gdpr_job_event_rule_name}"
  name_prefix                               = "${local.name_prefix}"
  step_function_name                        = "${local.cig_gdpr_step_function_name}"
  accountid                                 = "${var.accountid}"
  step_function_arn                         = "${aws_sfn_state_machine.dsci_gdpr_job_state_machine.id}"
  tags                                      = "${var.default_tags}"
  gdpr_job_event_rule_enabled               = "${var.gdpr_job_event_rule_enabled}"
  eol_data_crawler_name                     = "${var.eol_crawler_name}"
  eol_database_name                         = "${var.eol_database_name}"
  fargate_cluster_arn                       = "${aws_ecs_cluster.cig_ecs_gdpr_cluster.arn}"
  sqs_queue_name                            = "${local.cig_gdpr_requests_queue_name}"
  emr_sqs_queue_name                        = "${local.cig_gdpr_requests_emr_queue_name}"
  task_definition_arn                       = "${aws_ecs_task_definition.send_gdpr_requests_to_sqs_and_dynamodb_task_definition.arn}"
  cig_gdpr_log_dynamodb_table_name          = "${local.cig_gdpr_log_dynamodb_table_name}"
  cig_database_name                         = "${var.cig_database_name}"
  emr_install_dependencies_script_s3_key    = "${aws_s3_bucket_object.gdpr_install_dependencies.id}"
  cig_gdpr_bucket_name                      = "${local.cig_gdpr_bucket_name}"
  process_gdpr_requests_script_s3_key       = "${aws_s3_bucket_object.process_emr_gdpr_requests.id}"
  ecs_subnet_id                             = "${var.ecs_subnet_id}"
  emr_subnet_id                             = "${var.emr_subnet_id}"
}

module "step-function-gdpr-job-failure-event-rule" {
  source                 = "./cloudwatch-event-rules/step-function-failure"
  step_function_name     = "${local.cig_gdpr_step_function_name}"
  step_function_arn      = "${aws_sfn_state_machine.dsci_gdpr_job_state_machine.id}"
  notification_topic_arn = "${data.aws_sns_topic.info_topic.arn}"
}

module "lambdas" {
  source                             = "./lambdas"
  default_tags                       = "${var.default_tags}"
  name_prefix                        = "${local.name_prefix}"
  accountid                          = "${var.accountid}"
  gdpr_requests_sqs_queue_arn        = "${aws_sqs_queue.gdpr_requests_queue.arn}"
  gdpr_requests_sqs_queue_name       = "${local.cig_gdpr_requests_queue_name}"
  gdpr_log_table_name                = "${local.cig_gdpr_log_dynamodb_table_name}"
  gdpr_log_dynamodb_arn              = "${aws_dynamodb_table.dynamodb_gdpr_log_table.arn}"
  environment                        = "${var.environment}"
  region                             = "${var.region}"
}
