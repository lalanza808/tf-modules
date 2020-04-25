output "account_id" {
  value = aws_organizations_account.this.id
}

output "account_arn" {
  value = aws_organizations_account.this.arn
}
