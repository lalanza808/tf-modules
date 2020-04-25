locals {
  cft_file   = "${path.module}/files/init.yaml"
  cft_script = "${path.module}/files/account_init.sh"
}

data "local_file" "init_cft" {
  filename = local.cft_file
}

resource "aws_organizations_account" "this" {
  name                       = var.account_name
  email                      = var.account_email
  iam_user_access_to_billing = var.iam_billing_access
  parent_id                  = var.parent_ou_id
  role_name                  = var.access_role_name
  tags                       = var.tags

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = ["role_name"]
  }
}

resource "null_resource" "initialize" {
  triggers = {
    file_content = data.local_file.init_cft.content_base64
  }

  provisioner "local-exec" {
    command = local.cft_script

    environment = {
      STACK_NAME          = var.init_stack_name
      FILE_PATH           = local.cft_file
      REGION              = var.init_stack_region
      ACCOUNT_ID          = aws_organizations_account.this.id
      ROLE_NAME           = var.access_role_name
      ACCOUNT_NAME        = var.account_name
      MASTER_ACCOUNT_ID   = var.master_account_id
      MASTER_ACCOUNT_ROLE = var.master_account_role
    }
  }
}
