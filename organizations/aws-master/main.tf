data "aws_caller_identity" "current" {}

resource "aws_organizations_organization" "org" {
  aws_service_access_principals = var.service_principals
  enabled_policy_types          = var.scp_types
  feature_set                   = var.feature_set
}

resource "aws_organizations_organizational_unit" "prod" {
  name      = "Production"
  parent_id = aws_organizations_organization.org.roots.0.id
}

resource "aws_organizations_organizational_unit" "non_prod" {
  name      = "NonProduction"
  parent_id = aws_organizations_organization.org.roots.0.id
}

resource "aws_organizations_policy" "prod" {
  name  = "Production"

  content = <<CONTENT
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "*",
    "Resource": "*"
  }
}
CONTENT
}

resource "aws_organizations_policy" "non_prod" {
  name  = "NonProduction"

  content = <<CONTENT
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "*",
    "Resource": "*"
  }
}
CONTENT
}

resource "aws_organizations_policy_attachment" "prod" {
  policy_id = aws_organizations_policy.prod.id
  target_id = aws_organizations_organizational_unit.prod.id
}

resource "aws_organizations_policy_attachment" "non_prod" {
  policy_id = aws_organizations_policy.non_prod.id
  target_id = aws_organizations_organizational_unit.non_prod.id
}
