resource "aws_config_config_rule" "vpc_flow_logs_enabled" {
  count = var.enable_aws_config && var.rule_vpc_flow_logs_enabled ? 1 : 0
  name  = "vpc-flow-logs-enabled"

  source {
    owner             = "AWS"
    source_identifier = "VPC_FLOW_LOGS_ENABLED"
  }
  tags = var.tags

  input_parameters = <<EOF
{
  "trafficType": "ALL"
}
EOF
  depends_on       = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_config_rule" "incoming_ssh_enabled" {
  count = var.enable_aws_config && var.rule_incoming_ssh_enabled ? 1 : 0
  name  = "restricted-ssh"

  source {
    owner             = "AWS"
    source_identifier = "INCOMING_SSH_DISABLED"
  }
  tags       = var.tags
  depends_on = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_config_rule" "restricted_common_ports" {
  count = var.enable_aws_config && var.rule_restricted_common_ports ? 1 : 0
  name  = "restricted-common-ports"

  source {
    owner             = "AWS"
    source_identifier = "RESTRICTED_INCOMING_TRAFFIC"
  }
  tags = var.tags

  input_parameters = <<EOF
{
  "blockedPort1": "3306",
  "blockedPort2": "3389"
}
EOF
  depends_on       = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_config_rule" "default_security_group_closed" {
  count = var.enable_aws_config && var.rule_default_security_group_closed ? 1 : 0
  name  = "vpc-default-security-group-closed"

  source {
    owner             = "AWS"
    source_identifier = "VPC_DEFAULT_SECURITY_GROUP_CLOSED"
  }
  tags       = var.tags
  depends_on = [aws_config_configuration_recorder.config_recorder]
}
