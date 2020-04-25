resource "aws_iam_role" "cloudtrail_log_group_role" {
  name = aws_s3_bucket.cloudtrail_bucket.id
  tags = var.tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudtrail_log_group_role_policy" {
  name = aws_s3_bucket.cloudtrail_bucket.id
  role = aws_iam_role.cloudtrail_log_group_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "logs:CreateLogStream",
            "Resource": "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}",
            "Effect": "Allow"
        },
        {
            "Action": "logs:PutLogEvents",
            "Resource": "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}",
            "Effect": "Allow"
        }
    ]
}
EOF
}
