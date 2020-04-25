resource "aws_s3_bucket" "config_bucket" {
  count         = var.enable_aws_config ? 1 : 0
  bucket_prefix = "${var.prefix}-config-"
  acl           = "private"
  force_destroy = var.force_destroy_bucket

  tags = var.tags

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "archive_glacier"
    enabled = var.lifecycle_enabled
    prefix  = var.lifecycle_prefix

    transition {
      days          = var.lifecycle_glacier_transition_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.lifecycle_object_expiration
    }
  }
}

resource "aws_s3_bucket_policy" "config_bucket_policy" {
  count  = var.enable_aws_config ? 1 : 0
  bucket = aws_s3_bucket.config_bucket[0].id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSConfigAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "config.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.config_bucket[0].arn}"
        },
        {
            "Sid": "AWSConfigWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "config.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.config_bucket[0].arn}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_config_delivery_channel" "delivery_channel" {
  count          = var.enable_aws_config ? 1 : 0
  name           = aws_s3_bucket.config_bucket[0].id
  s3_bucket_name = aws_s3_bucket.config_bucket[0].id
  sns_topic_arn  = var.sns_topic_arn
  depends_on     = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_configuration_recorder_status" "config_status" {
  count      = var.enable_aws_config ? 1 : 0
  name       = aws_config_configuration_recorder.config_recorder[0].name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.delivery_channel]
}

resource "aws_config_configuration_recorder" "config_recorder" {
  count    = var.enable_aws_config ? 1 : 0
  name     = aws_s3_bucket.config_bucket[0].id
  role_arn = aws_iam_role.config_recorder_role[0].arn

  recording_group {
    all_supported                 = "true"
    include_global_resource_types = "true"
  }
}

resource "aws_iam_role" "config_recorder_role" {
  count = var.enable_aws_config ? 1 : 0
  name  = aws_s3_bucket.config_bucket[0].id
  tags  = var.tags

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "config_s3" {
  count  = var.enable_aws_config ? 1 : 0
  name   = aws_iam_role.config_recorder_role[0].name
  role   = aws_iam_role.config_recorder_role[0].id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:*"
            ],
            "Resource": [
              "${aws_s3_bucket.config_bucket[0].arn}",
              "${aws_s3_bucket.config_bucket[0].arn}/*"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
}

// Config service policy attachment
resource "aws_iam_role_policy_attachment" "config_role" {
  count      = var.enable_aws_config ? 1 : 0
  role       = aws_iam_role.config_recorder_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}
