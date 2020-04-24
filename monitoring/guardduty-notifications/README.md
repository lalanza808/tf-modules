# guardduty-notifications

This module sets up Cloudwatch Event rules which both logs to Cloudwatch and notifies a given SNS topic to inform administrators of any Guard Duty findings.

https://aws.amazon.com/guardduty/

## Usage

```
module "guardduty-notifications" {
  source = "github.com/lalanza808/tf-modules.git/monitoring/guardduty-notifications"
}
```

## Inputs

You should provide the following input, which is the SNS Topic ARN you wish to publish messages to:

* `sns_topic_arn`

If you don't provide it, the results will still be emitted to a Cloudwatch Logs group.

You can override the following inputs:

* `prefix`
* `tags`
* `log_retention`

See all inputs here: [variables.tf](./variables.tf)
