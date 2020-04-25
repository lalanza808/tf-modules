// Resource attritbute output

output "config_bucket" {
  value = aws_s3_bucket.config_bucket[0].id
}
