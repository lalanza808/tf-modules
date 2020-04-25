resource "aws_cur_report_definition" "cur" {
  report_name                = aws_s3_bucket.cur.id
  time_unit                  = var.time_unit
  format                     = "textORcsv"
  compression                = "GZIP"
  additional_schema_elements = ["RESOURCES"]
  s3_bucket                  = aws_s3_bucket.cur.id
  s3_region                  = "us-east-1"
  additional_artifacts       = var.additional_artifacts
}

resource "aws_s3_bucket" "cur" {
  bucket_prefix = "${var.prefix}-cur-"
  force_destroy = var.force_destroy_bucket
  region        = "us-east-1"
  tags          = var.tags
}

resource "aws_s3_bucket_policy" "cur" {
  bucket = aws_s3_bucket.cur.id

  policy = <<POLICY
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "CURReadAccess",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": [
                "s3:GetBucketAcl",
                "s3:GetBucketPolicy"
            ],
            "Resource": "${aws_s3_bucket.cur.arn}"
        },
        {
            "Sid": "CURWriteAccess",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.cur.arn}/*"
        }
    ]
}
POLICY
}
