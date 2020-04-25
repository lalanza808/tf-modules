// Resource attritbute output

output "s3_bucket" {
  value = aws_s3_bucket.cloudtrail_bucket.id
}

output "trail_name" {
  value = aws_cloudtrail.cloudtrail_bucket_logging.id
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.cloudtrail_log_group.name
}
