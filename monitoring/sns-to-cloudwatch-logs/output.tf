output "lambda_function_arn" {
  value = aws_lambda_function.lambda.arn
}

output "log_group_arn" {
  value = aws_cloudwatch_log_group.logs.arn
}

output "sns_topic_arn" {
  value = aws_sns_topic.this.arn
}
