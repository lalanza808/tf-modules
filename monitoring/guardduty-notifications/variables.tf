variable "sns_topic_arn" {
  description = "ARN of the SNS topic to recieve notifications"
  default     = ""
}
variable "tags" {
  default     = {}
  type        = map
  description = "Optional set of tags to apply to the infrastructure"
}
variable "prefix" {
  default     = "security"
  description = "String to prefix to all resources"
}
variable "log_retention" {
  default = 90
}
