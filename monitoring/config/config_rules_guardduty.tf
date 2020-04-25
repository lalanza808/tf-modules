resource "aws_config_config_rule" "guardduty_enabled" {
  count                       = var.enable_aws_config && var.rule_guardduty_enabled ? 1 : 0
  name                        = "guardduty-enabled-centralized"
  maximum_execution_frequency = "TwentyFour_Hours"

  source {
    owner             = "AWS"
    source_identifier = "GUARDDUTY_ENABLED_CENTRALIZED"
  }
  tags       = var.tags
  depends_on = [aws_config_configuration_recorder.config_recorder]
}
