resource "aws_sqs_queue" "gdpr_requests_queue" {
  name                       = "${local.cig_gdpr_requests_queue_name}"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"

  tags                       = "${var.default_tags}"
}

resource "aws_sqs_queue_policy" "gdpr_requests_queue_policy" {
  queue_url = "${aws_sqs_queue.gdpr_requests_queue.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "gdpr_requests_queue_policy",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "sqs:GetQueueUrl",
        "sqs:ListQueues",
        "sqs:ReceiveMessage",
        "sqs:SendMessage"
      ],
      "Resource": "${aws_sqs_queue.gdpr_requests_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sqs_queue.gdpr_requests_queue.arn}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sqs_queue" "gdpr_requests_emr_queue" {
  name                       = "${local.cig_gdpr_requests_emr_queue_name}"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"

  tags                       = "${var.default_tags}"
}

resource "aws_sqs_queue_policy" "gdpr_requests_emr_queue_policy" {
  queue_url = "${aws_sqs_queue.gdpr_requests_emr_queue.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "gdpr_requests_emr_queue_policy",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "sqs:GetQueueUrl",
        "sqs:ListQueues",
        "sqs:ReceiveMessage",
        "sqs:SendMessage"
      ],
      "Resource": "${aws_sqs_queue.gdpr_requests_emr_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sqs_queue.gdpr_requests_emr_queue.arn}"
        }
      }
    }
  ]
}
POLICY
}