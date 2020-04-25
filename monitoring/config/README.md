# Config

This modules sets up AWS Config for auditing the account and alerting on insecure conditions.

There is a list of pre-made Config rules authored by AWS here: https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html

I only picked the most obvious ones because there are a ton of available rules but they can cost a lot to turn them all on.

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

module "config" {
  source = "github.com/lalanza808/tf-modules.git/monitoring/config"

  sns_topic_arn = module.sns_topic.topic_arn
  s3_buckets_logging_enabled = [
    module.cloudtrail.s3_bucket
  ]
}
```

## Inputs

The main ones you would want to override are:

* `sns_topic_arn` - An SNS topic ARN for notifying when a Config rule has breached
* `s3_buckets_logging_enabled` - A list of buckets to create Config rules for monitoring Cloudtrail data plane operations log collection

See the full list of inputs here: [variables.tf](./variables.tf)

## Outputs

[output.tf](./output.tf)
