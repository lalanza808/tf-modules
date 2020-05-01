data "aws_iam_policy_document" "vpn_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "vpn" {
  statement {
    actions = [
      "route53:ListHostedZones",
      "route53:GetChange"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "route53:ChangeResourceRecordSets"
    ]
    resources = [
      "arn:aws:route53:::hostedzone/${data.aws_route53_zone.domain.zone_id}"
    ]
  }
  statement {
    actions = [
      "ec2:AssociateAddress",
      "ec2:DescribeInstances",
      "ec2:DescribeNetworkInterfaces"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "s3:Put*",
      "s3:Get*"
    ]
    resources = [
      "${aws_s3_bucket.configs.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "vpn" {
  name_prefix = aws_iam_role.vpn.name
  description = "WireGuard VPN server policy for managing resources on AWS"
  policy      = data.aws_iam_policy_document.vpn.json
}

resource "aws_iam_role" "vpn" {
  name_prefix        = "${var.prefix}-vpn-"
  assume_role_policy = data.aws_iam_policy_document.vpn_assume_role.json
}

resource "aws_iam_role_policy_attachment" "vpn" {
  role       = aws_iam_role.vpn.name
  policy_arn = aws_iam_policy.vpn.arn
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.vpn.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "vpn" {
  name = aws_iam_role.vpn.name
  role = aws_iam_role.vpn.name
}
