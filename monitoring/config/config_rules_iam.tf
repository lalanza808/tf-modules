resource "aws_config_config_rule" "root_access_keys" {
  count                       = var.enable_aws_config && var.rule_root_access_keys ? 1 : 0
  name                        = "iam-root-access-key-check"
  maximum_execution_frequency = "TwentyFour_Hours"

  source {
    owner             = "AWS"
    source_identifier = "IAM_ROOT_ACCESS_KEY_CHECK"
  }
  tags       = var.tags
  depends_on = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_config_rule" "root_mfa_enabled" {
  count                       = var.enable_aws_config && var.rule_root_mfa_enabled ? 1 : 0
  name                        = "root-account-mfa-enabled"
  maximum_execution_frequency = "TwentyFour_Hours"

  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }
  tags       = var.tags
  depends_on = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_config_rule" "root_hardware_mfa_enabled" {
  count                       = var.enable_aws_config && var.rule_root_hardware_mfa_enabled ? 1 : 0
  name                        = "root-account-hardware-mfa-enabled"
  maximum_execution_frequency = "TwentyFour_Hours"

  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_HARDWARE_MFA_ENABLED"
  }
  tags       = var.tags
  depends_on = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_config_rule" "console_mfa_enabled" {
  count                       = var.enable_aws_config && var.rule_console_mfa_enabled ? 1 : 0
  name                        = "mfa-enabled-for-iam-console-access"
  maximum_execution_frequency = "TwentyFour_Hours"

  source {
    owner             = "AWS"
    source_identifier = "MFA_ENABLED_FOR_IAM_CONSOLE_ACCESS"
  }
  tags       = var.tags
  depends_on = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_config_rule" "iam_user_unused" {
  count                       = var.enable_aws_config && var.rule_iam_user_unused ? 1 : 0
  name                        = "iam-user-unused-credentials-check"
  maximum_execution_frequency = "TwentyFour_Hours"

  source {
    owner             = "AWS"
    source_identifier = "IAM_USER_UNUSED_CREDENTIALS_CHECK"
  }
  tags = var.tags

  input_parameters = <<EOF
{
  "maxCredentialUsageAge": "90"
}
EOF
  depends_on       = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_config_rule" "iam_password_policy_enabled" {
  count                       = var.enable_aws_config && var.rule_iam_password_policy_enabled ? 1 : 0
  name                        = "iam-password-policy-enabled"
  maximum_execution_frequency = "TwentyFour_Hours"

  source {
    owner             = "AWS"
    source_identifier = "IAM_PASSWORD_POLICY"
  }
  tags = var.tags

  input_parameters = <<EOF
{
  "MinimumPasswordLength": "14",
  "RequireUppercaseCharacters": "true",
  "RequireLowercaseCharacters": "true",
  "RequireSymbols": "true",
  "RequireNumbers": "true",
  "PasswordReusePrevention": "24",
  "MaxPasswordAge": "90"
}
EOF
  depends_on       = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_config_rule" "iam_policy_no_admin" {
  count = var.enable_aws_config && var.rule_iam_policy_no_admin ? 1 : 0
  name  = "iam-policy-no-statements-with-admin-access"

  source {
    owner             = "AWS"
    source_identifier = "IAM_POLICY_NO_STATEMENTS_WITH_ADMIN_ACCESS"
  }
  tags       = var.tags
  depends_on = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_config_rule" "access_keys_rotated" {
  count                       = var.enable_aws_config && var.rule_access_keys_rotated ? 1 : 0
  name                        = "access-keys-rotated"
  maximum_execution_frequency = "TwentyFour_Hours"

  source {
    owner             = "AWS"
    source_identifier = "ACCESS_KEYS_ROTATED"
  }
  tags = var.tags

  input_parameters = <<EOF
{
  "maxAccessKeyAge": "90"
}
EOF
  depends_on       = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_config_rule" "iam_user_no_policies" {
  count = var.enable_aws_config && var.rule_iam_user_no_policies ? 1 : 0
  name  = "iam-user-no-policies-check"

  source {
    owner             = "AWS"
    source_identifier = "IAM_USER_NO_POLICIES_CHECK"
  }
  tags       = var.tags
  depends_on = [aws_config_configuration_recorder.config_recorder]
}
