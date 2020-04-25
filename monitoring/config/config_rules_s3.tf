resource "aws_config_config_rule" "s3_public_read_prohibited" {
  count = var.enable_aws_config && var.rule_s3_public_read_prohibited ? 1 : 0
  name  = "s3-bucket-public-read-prohibited"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }
  tags       = var.tags
  depends_on = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_config_rule" "s3_logging_enabled" {
  name = "s3-bucket-logging-enabled"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_LOGGING_ENABLED"
  }
  tags = var.tags

  input_parameters = <<EOF
{
  "targetBucket": "*",
  "targetPrefix": "/"
}
EOF
  depends_on       = [aws_config_configuration_recorder.config_recorder]
}
