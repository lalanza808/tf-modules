variable "scp_types" {
  type        = list
  default     = ["SERVICE_CONTROL_POLICY"]
  description = "List of SCP types - can be overridden to none or empty list for no SCP"
}

variable "additional_artifacts" {
  default = ["QUICKSIGHT"]
}

variable "feature_set" {
  default     = "ALL"
  description = "Organizations features to setup"
}

variable "service_principals" {
  type = list
  default = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]
  description = "List of services to allow"
}

variable "force_destroy_bucket" {
  default     = false
  description = "Whether or not you want the bucket to force removal of all objects upon deletion - otherwise throws error when deleting"
}

variable "time_unit" {
  default     = "DAILY"
  description = "The frequency on which report data are measured and displayed. Valid values are: HOURLY, DAILY."
}

variable "tags" {
  default     = {}
  type        = map
  description = "Optional set of tags to apply to the infrastructure"
}

variable "prefix" {
  default     = "organizations"
  description = "String to prefix to all resources"
}
