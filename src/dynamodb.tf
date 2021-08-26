resource "aws_dynamodb_table" "dynamodb_gdpr_log_table" {
  name           = "${local.cig_gdpr_log_dynamodb_table_name}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "MessageId"

  attribute {
    name = "MessageId"
    type = "S"
  }

  tags = "${var.default_tags}"
}
