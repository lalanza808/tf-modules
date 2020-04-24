variable "sns_emails" {
  type = list
  default = []
}
variable "tags" {
  default     = {}
  type        = map
  description = "Optional tag mapping to apply to the infrastructure"
}
variable "prefix" {
  default     = "monitoring"
  description = "String to prefix to all resources"
}
