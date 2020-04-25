resource "aws_cloudwatch_log_group" "logs" {
  name              = var.namespace
  retention_in_days = var.log_group_retention_days
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.namespace}"
  retention_in_days = var.lambda_log_retention_days
}
