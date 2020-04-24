variable "regions" {
  description = "Which regions to deploy Guard Duty into"
  type        = "list"
  default = [
    "ap-south-1",
    "eu-west-3",
    "eu-west-2",
    "eu-west-1",
    "ap-northeast-2",
    "ap-northeast-1",
    "sa-east-1",
    "ca-central-1",
    "ap-southeast-1",
    "ap-southeast-2",
    "eu-central-1",
    "us-east-1",
    "us-west-2",
    "us-east-2",
    "us-west-1"
  ]
}

variable "tags" {
  default     = {}
  type        = "map"
  description = "Optional tag mapping to apply to the infrastructure"
}

variable "prefix" {
  default     = ""
  description = "String to prefix to all resources"
}
