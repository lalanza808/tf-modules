resource "aws_config_config_rule" "cloudtrail_enabled" {
  count                       = var.enable_aws_config && var.rule_cloudtrail_enabled ? 1 : 0
  name                        = "multi-region-cloud-trail-enabled"
  maximum_execution_frequency = "TwentyFour_Hours"

  source {
    owner             = "AWS"
    source_identifier = "MULTI_REGION_CLOUD_TRAIL_ENABLED"
  }
  tags       = var.tags
  depends_on = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_config_rule" "cloudtrail_validation_enabled" {
  count                       = var.enable_aws_config && var.rule_cloudtrail_validation_enabled ? 1 : 0
  name                        = "cloud-trail-log-validation-enabled"
  maximum_execution_frequency = "TwentyFour_Hours"

  source {
    owner             = "AWS"
    source_identifier = "CLOUD_TRAIL_LOG_FILE_VALIDATION_ENABLED"
  }
  tags       = var.tags
  depends_on = [aws_config_configuration_recorder.config_recorder]
}



resource "aws_config_config_rule" "cloudtrail_cloudwatch_logs_enabled" {
  count                       = var.enable_aws_config && var.rule_cloudtrail_cloudwatch_logs_enabled ? 1 : 0
  name                        = "cloud-trail-cloud-watch-logs-enabled"
  maximum_execution_frequency = "TwentyFour_Hours"

  source {
    owner             = "AWS"
    source_identifier = "CLOUD_TRAIL_CLOUD_WATCH_LOGS_ENABLED"
  }
  tags       = var.tags
  depends_on = [aws_config_configuration_recorder.config_recorder]
}
