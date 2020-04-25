data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "archive_file" "functions" {
  type        = "zip"
  source_dir  = local.source_funcs
  output_path = local.archive_funcs
}

locals {
  source_funcs  = "${path.module}/lambda/"
  archive_funcs = "${path.module}/lambda/functions.zip"
  region        = data.aws_region.current.name
  account_id    = data.aws_caller_identity.current.account_id
}
