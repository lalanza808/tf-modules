output "kms_key_id" {
  value = aws_kms_key.kms.key_id
}

output "kms_key_alias" {
  value = var.app_name
}
