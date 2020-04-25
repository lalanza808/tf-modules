data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "cloudtrail_bucket_logging" {
  name                          = aws_s3_bucket.cloudtrail_bucket.id
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  include_global_service_events = var.include_global_service_events
  is_multi_region_trail         = var.is_multi_region_trail
  enable_logging                = var.enable_logging
  enable_log_file_validation    = var.enable_log_file_validation
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_log_group_role.arn
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.cloudtrail_log_group.arn
  kms_key_id                    = aws_kms_key.cloudtrail.arn
  tags                          = var.tags

  event_selector {
    read_write_type           = "All"
    include_management_events = var.include_management_events

    data_resource {
      type = "AWS::S3::Object"
      values = compact(concat(
        [var.default_log_bucket],
        formatlist("arn:aws:s3:::%s/", var.activity_log_buckets)
      ))
    }
  }
}
