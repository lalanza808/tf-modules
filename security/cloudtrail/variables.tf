variable "include_management_events" {
  default     = true
  description = "Whether or not you want to include management events"
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
  default     = 365
  description = "Number of days to maintain in S3 until transitioning to Glacier"
}
variable "enable_key_rotation" {
  default = true
}
variable "lifecycle_object_expiration" {
  default     = 1825
  description = "Number of days to expire objects permanently"
}
variable "cloudwatch_log_retention" {
  default     = 90
  description = "Number of days to maintain Cloudtrail events in Cloudwatch Logs"
}
variable "force_destroy_bucket" {
  default     = false
  description = "Whether or not you want the bucket to force removal of all objects upon deletion - otherwise throws error when deleting"
}
variable "include_global_service_events" {
  default     = true
  description = "Whether or not to include global service events"
}
variable "is_multi_region_trail" {
  default     = true
  description = "Whether or not to use all regions"
}
variable "enable_logging" {
  default     = true
  description = "Whether or not to enable logging"
}
variable "enable_log_file_validation" {
  default     = true
  description = "Whether or not to enable log validation"
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
variable "activity_log_buckets" {
  description = "List of bucket ARNs to collect data plane operation logs for in addition to API events"
  type        = list
  default     = []
}
variable "default_log_bucket" {
  default     = "arn:aws:s3:::"
  description = "The default buckets to log - all buckets in the account - override to empty string"
}
