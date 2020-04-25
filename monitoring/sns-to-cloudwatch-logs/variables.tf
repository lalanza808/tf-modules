variable "namespace" {
  description = "Friendly name to refer to all module related resources"
}

variable "log_group_retention_days" {
  default = 90
}

variable "lambda_log_retention_days" {
  default = 90
}
