data "aws_caller_identity" "current" {}

data "local_file" "guardduty_cft" {
  filename = "${path.module}/files/guardduty.yaml"
}

# Stack Set Admin
resource "aws_iam_role" "stack_set_admin_role" {
  name               = "${var.prefix}-guardduty-ss-admin"
  tags               = var.tags
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "cloudformation.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "stack_set_admin_policy" {
  name   = aws_iam_role.stack_set_admin_role.name
  role   = aws_iam_role.stack_set_admin_role.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": "${aws_iam_role.stack_set_execution_role.arn}"
    }
  ]
}
EOF
}

# Stack Set Execution
resource "aws_iam_role" "stack_set_execution_role" {
  name               = "${var.prefix}-guardduty-ss-exec"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "${aws_iam_role.stack_set_admin_role.arn}"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "stack_set_execution_policy" {
  name   = aws_iam_role.stack_set_execution_role.name
  role   = aws_iam_role.stack_set_execution_role.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "guardduty:CreateDetector",
        "guardduty:ListDetectors",
        "guardduty:DeleteDetector",
        "guardduty:GetDetector",
        "cloudformation:CreateStack",
        "cloudformation:DescribeStacks",
        "cloudformation:DeleteStack",
        "SNS:Publish",
        "iam:CreateServiceLinkedRole"
      ],
      "Effect": "Allow",
      "Resource": ["*"]
    }
  ]
}
EOF
}


# Stack Sets
resource "aws_cloudformation_stack_set" "guardduty_stack_set" {
  administration_role_arn = aws_iam_role.stack_set_admin_role.arn
  name                    = "${var.prefix}-guardduty-stackset"
  template_body           = data.local_file.guardduty_cft.content
  execution_role_name     = aws_iam_role.stack_set_execution_role.name
  tags                    = var.tags
}

# Stack Set Instances
resource "aws_cloudformation_stack_set_instance" "guardduty_stack_set_instance" {
  count          = length(var.regions)
  account_id     = data.aws_caller_identity.current.account_id
  region         = var.regions[count.index]
  stack_set_name = aws_cloudformation_stack_set.guardduty_stack_set.id

  lifecycle {
    create_before_destroy = true
  }
}
