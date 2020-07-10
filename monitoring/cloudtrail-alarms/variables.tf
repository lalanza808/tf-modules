variable "log_group_name" {
  description = "Name of the Cloudwatch Logs group where Cloudtrail logs are flowing - used with Cloudwatch Alarms"
  default     = ""
}
variable "sns_topic_arn" {
  description = "ARN of an SNS topic to notify when alarms are breached - used with Cloudwatch Alarms"
  default     = ""
}
variable "tags" {
  default     = {}
  type        = map
  description = "Optional set of tags to apply to the infrastructure"
}
variable "account_name" {
  description = "Name of the AWS account so that monitors report correct labels"
}
variable "login_failures" {
  default = 3
}
variable "whitelist_iam_roles" {
  default = [
    "MissionCloudHealth",
    "MissionCloudAware",
    "security-guardduty-ss-exec",
    "security-guardduty-ss-admin",
    "config-recorder-role"
  ]
  description = "IAM role names that should not be alerted upon in CIS Benchmark alarms"
}
