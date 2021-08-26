resource "aws_sns_topic" "dsci_notifications_sns_topic" {
  name = "${local.notification_sns_topic_name}"

  tags = "${var.default_tags}"
}

resource "aws_sns_topic_policy" "default" {
  arn = "${aws_sns_topic.dsci_notifications_sns_topic.arn}"

  policy = "${data.aws_iam_policy_document.sns_topic_policy.json}"
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "${local.notification_sns_policy_name}"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    resources = [
      "${aws_sns_topic.dsci_notifications_sns_topic.arn}",
    ]
  }
}
