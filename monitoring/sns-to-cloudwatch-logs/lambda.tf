resource "aws_lambda_function" "lambda" {
  function_name     = var.namespace
  description       = "This lambda function takes incoming events from SNS and publishes them to a Cloudwatch Logs group. Useful for ingesting log streams into other platforms."
  s3_bucket         = aws_s3_bucket.lambda.id
  s3_key            = aws_s3_bucket_object.function.id
  s3_object_version = aws_s3_bucket_object.function.version_id
  role              = aws_iam_role.lambda.arn
  handler           = "send_event.handler"
  runtime           = "python3.7"
  timeout           = "5"
  memory_size       = "128"

  environment {
    variables = {
      log_group = var.namespace
    }
  }

  depends_on = [aws_cloudwatch_log_group.lambda]
}

resource "aws_lambda_permission" "lambda" {
  statement_id  = var.namespace
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.this.arn
}
