variable "usage_roles" {
  type        = list
  default     = []
  description = "IAM Role names which can use this key to decrypt secrets"
}
variable "app_name" {
  description = "Name of application SSM secrets are for"
}
variable "administrator_roles" {
  description = "IAM Role name of AWS account administrators"
  type = list
}
variable "tags" {
  default     = {}
  type        = map
  description = "Optional set of tags to apply to the infrastructure"
}
