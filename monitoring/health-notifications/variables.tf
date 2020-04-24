variable "sns_topic_arn" {
  description = "ARN of the SNS topic to recieve notifications"
}
variable "tags" {
  default     = {}
  type        = map
  description = "Optional set of tags to apply to the infrastructure"
}
variable "prefix" {
  default     = "monitoring"
  description = "String to prefix to all resources"
}
