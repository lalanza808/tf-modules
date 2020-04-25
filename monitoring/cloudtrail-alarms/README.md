# Cloudtrail Alarms

Hooks into an existing Cloudtrail and Cloudwatch Logs deployment enabled so that we can setup Log metric filters to look for certain patterns.

We are able to tail Cloudtrail events and alarm on certain log messages as they occur. The full list can be seen in [main.tf](./main.tf)

These alarms are necessary to be in compliance with CIS Benchmarks, a very popular framework for securing AWS environments.

## Usage

```
module "cloudtrail" {
  source               = "github.com/lalanza808/tf-modules.git/security/cloudtrail"
  force_destroy_bucket = true
}

module "sns_topic" {
  source     = "github.com/lalanza808/tf-modules.git/monitoring/sns-email-topic"
  sns_emails = ["user@email.com"]
}

module "cloudtrail-alarms" {
  source         = "github.com/lalanza808/tf-modules.git/monitoring/cloudtrail-alarms"
  log_group_name = module.cloudtrail.log_group_name
  sns_topic_arn  = module.sns_topic.topic_arn
  account_name   = "Sandbox"
}
```

## Inputs

* `log_group_name` - Cloudwatch Logs group containing Cloudtrail event data
* `sns_topic_arn` - The SNS topic ARN to publish event messages to based upon alarm conditions
* `account_name` - Name of the AWS account for labeling purposes

See the full list of inputs here: [variables.tf](./variables.tf)

## Outputs

None - [output.tf](./output.tf)
