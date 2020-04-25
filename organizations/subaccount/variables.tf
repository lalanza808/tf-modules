variable "iam_billing_access" {
  default = "ALLOW"
}

variable "access_role_name" {
  default = "OrganizationAccountAccessRole"
}

variable "master_account_id" {
  description = "Master AWS account ID where Organizations are provisioned"
  default     = "0000000000"
}

variable "master_account_role" {
  description = "Role to assume into Master AWS account"
  default     = "ManagementAccess"
}

variable "tags" {
  default = {}
  type    = "map"
}

variable "init_stack_name" {
  default     = "organizations-account-init"
  description = "Name of the Cloudformation stack to use"
}

variable "init_stack_region" {
  default     = "us-east-1"
  description = "Region to deploy the Cloudformation init stack into"
}

variable "parent_ou_id" {}
variable "account_name" {}
variable "account_email" {}
