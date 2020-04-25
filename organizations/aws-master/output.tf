output "prod_ou_id" {
  value = aws_organizations_organizational_unit.prod.id
}

output "non_prod_ou_id" {
  value = aws_organizations_organizational_unit.non_prod.id
}
