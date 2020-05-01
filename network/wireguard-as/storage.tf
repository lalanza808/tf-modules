resource "aws_s3_bucket" "configs" {
  bucket_prefix = "${var.prefix}-config-"
  acl           = "private"
}

data "aws_iam_policy_document" "config_policy" {
  statement {
    actions = [
      "s3:*"
    ]
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.vpn.arn
      ]
    }
    resources = [
      "${aws_s3_bucket.configs.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "configs" {
  bucket = aws_s3_bucket.configs.id
  policy = data.aws_iam_policy_document.config_policy.json
}
