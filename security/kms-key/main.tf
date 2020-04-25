data "aws_caller_identity" "this" {}

locals {
  account_id = data.aws_caller_identity.this.account_id
}

data "aws_iam_policy_document" "kms" {
  statement {
    sid       = "Enable IAM User Permissions"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }
  statement {
    sid = "Allow administrators to manage"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = formatlist("arn:aws:iam::${local.account_id}:role/%s", var.administrator_roles)
    }
  }
  statement {
    sid = "Allow use of the key by other roles"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = formatlist("arn:aws:iam::${local.account_id}:role/%s", var.usage_roles)
    }
  }
  statement {
    sid = "Allow attachment of persistent resources"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = formatlist("arn:aws:iam::${local.account_id}:role/%s", var.usage_roles)
    }
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values = [
        "true"
      ]
    }
  }
}

resource "aws_kms_key" "kms" {
  description = "KMS key for encrypting/decrypting secrets for ${var.app_name}"
  policy      = data.aws_iam_policy_document.kms.json
}

resource "aws_kms_alias" "kms" {
  name          = "alias/${var.app_name}"
  target_key_id = aws_kms_key.kms.key_id
}
