data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["application-autoscaling.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "state_machine_role" {
  name               = "${local.cig_gdpr_state_machine_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.state_machine_assume_role_policy_document.json}"
  tags               = "${var.default_tags}"
}

resource "aws_iam_role" "gdpr_ecs_run_task_role" {
  name               = "${local.cig_run_ecs_task_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.gdpr_ecs_run_task_assume_role_policy.json}"

  tags = "${var.default_tags}"
}

resource "aws_iam_role_policy" "iam_policy_for_gdpr_ecs_run_task_role" {
  name   = "${local.cig_run_ecs_task_policy_name}"
  role   = "${aws_iam_role.gdpr_ecs_run_task_role.id}"
  policy = "${data.aws_iam_policy_document.gdpr_ecs_run_task_assume_policy_document.json}"
}
