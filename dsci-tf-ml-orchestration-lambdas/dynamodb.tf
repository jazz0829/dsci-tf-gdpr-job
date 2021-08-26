resource "aws_dynamodb_table" "dynamodb_endpoints_bookmark_table" {
  name           = "${local.bookmark_db_name}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "EndpointName"

  attribute {
    name = "EndpointName"
    type = "S"
  }

  tags = "${var.default_tags}"
}
