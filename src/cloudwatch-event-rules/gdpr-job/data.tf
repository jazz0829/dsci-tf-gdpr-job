data "aws_iam_policy_document" "cloudwatch_assume_role_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudwatch_start_execution_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "states:StartExecution",
    ]

    resources = [
      "${var.step_function_arn}",
    ]
  }
}

data "template_file" "event_input" {
  template = "${file(var.start_gdpr_job_event_input_file)}"

  vars = {
    eol_data_crawler_name                  = "${var.eol_data_crawler_name}"
    eol-database-name                      = "${var.eol_database_name}"
    athena_query_output_location           = "s3://aws-athena-query-results-${var.accountid}-eu-west-1/gdpr/"
    fargate-cluster-arn                    = "${var.fargate_cluster_arn}"
    task-definition-arn                    = "${var.task_definition_arn}"
    sqs_queue_name                         = "${var.sqs_queue_name}"
    emr_sqs_queue_name                     = "${var.emr_sqs_queue_name}"
    ecs_subnet_id                          = "${var.ecs_subnet_id}"
    emr_subnet_id                          = "${var.emr_subnet_id}"
    cig_gdpr_log_dynamodb_table_name       = "${var.cig_gdpr_log_dynamodb_table_name}"
    low_write_capacity_units               = "${var.low_write_capacity_units}"
    high_write_capacity_units              = "${var.high_write_capacity_units}"
    high_read_capacity_units               = "${var.high_read_capacity_units}"
    low_read_capacity_units                = "${var.low_read_capacity_units}"
    cig-database-name                      = "${var.cig_database_name}"
    athena_query_cig_output_location       = "s3://aws-athena-query-results-${var.accountid}-eu-west-1/cig_gdpr/"
    emr_install_dependencies_script        = "s3://${var.cig_gdpr_bucket_name}/${var.emr_install_dependencies_script_s3_key}"
    process_gdpr_requests_script           = "s3://${var.cig_gdpr_bucket_name}/${var.process_gdpr_requests_script_s3_key}"
    emr_core_node_instance_type            = "${var.emr_core_node_instance_type}"
    emr_core_node_instance_count           = "${var.emr_core_node_instance_count}"
    emr_master_node_instance_count         = "${var.emr_master_node_instance_count}"
    emr_master_node_instance_type          = "${var.emr_master_node_instance_type}"
    emr_log_output                         = "s3://${var.cig_gdpr_bucket_name}/emr-logs/"
  }
}
