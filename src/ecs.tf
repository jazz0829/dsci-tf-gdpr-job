resource "aws_ecs_cluster" "cig_ecs_gdpr_cluster" {
  name = "${local.cig_ecs_cluster_name}"

  tags = "${var.default_tags}"
}

resource "aws_ecs_task_definition" "send_gdpr_requests_to_sqs_and_dynamodb_task_definition" {
  family                   = "SendGdprRequestsToSqs"
  execution_role_arn       = "${aws_iam_role.gdpr_ecs_run_task_role.arn}"
  task_role_arn            = "${aws_iam_role.gdpr_ecs_run_task_role.arn}"
  memory                   = "30720"
  cpu                      = "4096"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  tags                     = "${var.default_tags}"

  container_definitions = <<DEFINITION
  [
  {
        "environment": [
        ],
        "logConfiguration": {
          "logDriver": "awslogs",
          "secretOptions": null,
          "options": {
            "awslogs-group": "/aws/ecs/${local.cig_ecs_cluster_name}",
            "awslogs-region": "eu-west-1",
            "awslogs-stream-prefix": "ecs"
          }
        },
        "image": "428785023349.dkr.ecr.eu-west-1.amazonaws.com/dsci-send-gdpr-requests-to-sqs:branch-master",
        "essential": true,
        "name": "gdpr"
      }
  ]
  DEFINITION
}

resource "aws_cloudwatch_log_group" "gdpr_cluster_log_group" {
  name = "/aws/ecs/${local.cig_ecs_cluster_name}"

  tags = "${var.default_tags}"
}
