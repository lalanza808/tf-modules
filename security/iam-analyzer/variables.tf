variable "name" {
  default = "ctay-iam-analyzer"
}

variable "tags" {
  default     = {}
  type        = map
  description = "Optional tag mapping to apply to the infrastructure"
}
