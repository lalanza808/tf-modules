// Storage for versioned Lambda functions
resource "aws_s3_bucket" "lambda" {
  bucket_prefix = "${var.namespace}-lambda-"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_object" "function" {
  bucket = aws_s3_bucket.lambda.id
  key    = "lambda_functions.zip"
  source = data.archive_file.functions.output_path
  etag   = data.archive_file.functions.output_md5
}
