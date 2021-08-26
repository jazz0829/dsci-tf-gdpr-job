output "function_arn" {
  value = "${aws_lambda_function.lambda.arn}"
}

output "function_role_arn" {
  value = "${aws_iam_role.iam_for_lambda.arn}"
}
