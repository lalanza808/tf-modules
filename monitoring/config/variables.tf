variable "enable_aws_config" {
  default     = true
  description = "Whether or not you want Config"
}
variable "force_destroy_bucket" {
  default     = false
  description = "Whether or not you want the bucket to force removal of all objects upon deletion - otherwise throws error when deleting"
}
variable "sns_topic_arn" {
  default     = ""
  description = "SNS Topic to forward Config messages to"
}
variable "lifecycle_enabled" {
  default     = true
  description = "Whether or not to enable lifecycle rules"
}
variable "lifecycle_prefix" {
  default     = ""
  description = "S3 object prefix to manage lifecycle - blank is all objects"
}
variable "lifecycle_glacier_transition_days" {
  default     = 90
  description = "Number of days to maintain in S3 until transitioning to Glacier"
}
variable "lifecycle_object_expiration" {
  default     = 365
  description = "Number of days to expire objects permanently"
}
variable "s3_buckets_logging_enabled" {
  type        = list
  default     = []
  description = "A list of S3 buckets you want to run Config checks for ensuring logging is enabled"
}
variable "rule_cloudtrail_enabled" {
  default = true
}
variable "rule_cloudtrail_validation_enabled" {
  default = true
}
variable "rule_guardduty_enabled" {
  default = true
}
variable "rule_root_access_keys" {
  default = true
}
variable "rule_root_mfa_enabled" {
  default = true
}
variable "rule_root_hardware_mfa_enabled" {
  default = true
}
variable "rule_console_mfa_enabled" {
  default = true
}
variable "rule_iam_user_unused" {
  default = true
}
variable "rule_iam_password_policy_enabled" {
  default = true
}
variable "rule_iam_policy_no_admin" {
  default = true
}
variable "rule_access_keys_rotated" {
  default = true
}
variable "rule_iam_user_no_policies" {
  default = true
}
variable "rule_s3_public_read_prohibited" {
  default = true
}
variable "rule_cloudtrail_cloudwatch_logs_enabled" {
  default = true
}
variable "rule_s3_logging_enabled" {
  default = true
}
variable "rule_vpc_flow_logs_enabled" {
  default = true
}
variable "rule_incoming_ssh_enabled" {
  default = true
}
variable "rule_restricted_common_ports" {
  default = true
}
variable "rule_default_security_group_closed" {
  default = true
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
