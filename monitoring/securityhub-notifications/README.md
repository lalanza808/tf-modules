# securityhub-notifications

This module sets up Cloudwatch Event rules which notify a given SNS topic to inform administrators of any SecurityHub findings.

https://aws.amazon.com/security-hub/

## Usage

```
module "sns-email-topic" {
  source = "github.com/lalanza808/tf-modules.git/monitoring/sns-email-topic"
}

module "securityhub-notification" {
  source = "github.com/lalanza808/tf-modules.git/monitoring/securityhub-notifications"
  sns_topic_arn = module.sns-email-topic.topic_arn
}
```

## Inputs

You must provide one input, which is the SNS Topic ARN you wish to publish messages to.

* `sns_topic_arn`

You can provide these optional inputs:

* `prefix`
* `tags`

See all inputs here: [variables.tf](./variables.tf)

## Outputs

None
