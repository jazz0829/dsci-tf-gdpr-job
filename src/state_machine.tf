data "template_file" "sfn_definition" {
  template = "${file(var.step_function_definition_file)}"

  vars = {
    cig-sagemaker-slack-lambda-arn                                      = "${data.aws_lambda_function.notify_slack.arn}"
    cig-start-glue-crawler-lambda-arn                                   = "${module.lambdas.start_glue_crawler_lambda_function_arn}"
    cig-get-glue-crawler-status-lambda-arn                              = "${module.lambdas.get_glue_crawler_status_lambda_function_arn}"
    cig-query-data-lake-for-gdpr-requests-lambda-arn                    = "${module.lambdas.query_data_lake_for_gdpr_requests_lambda_function_arn}"
    cig-check-athena-query-status-lambda-arn                            = "${module.lambdas.check_athena_query_status_lambda_function_arn}"
    cig-run-ecs-task-lambda-arn                                         = "${module.lambdas.run_ecs_task_lambda_function_arn}"
    cig-get-queue-messages-count-lambda-arn                             = "${module.lambdas.get_sqs_queue_messages_count_lambda_function_arn}"
    cig-check-ecs-task-status-lambda-arn                                = "${module.lambdas.check_ecs_task_status_lambda_function_arn}"
    cig-update-dynamodb-capacity-lambda-arn                             = "${data.aws_lambda_function.update_dynamodb_capacity_lambda_function.arn}"
    dsci-sagemaker-emr-get-status-lambda-arn                            = "${data.aws_lambda_function.get_emr_cluster_status.arn}"
    dsci-sagemaker-run-emr-lambda-arn                                   = "${data.aws_lambda_function.run_emr_job.arn}"
  }
}

resource "aws_sfn_state_machine" "dsci_gdpr_job_state_machine" {
  name       = "${local.cig_gdpr_step_function_name}"
  role_arn   = "${aws_iam_role.state_machine_role.arn}"
  definition = "${data.template_file.sfn_definition.rendered}"

  tags = "${var.default_tags}"
}
