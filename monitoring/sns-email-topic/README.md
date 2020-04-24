# SNS Email Topic

Create an SNS topic that uses Email based notifications.

## Usage

```
module "sns_email_topic" {
  source = "github.com/lalanza808/tf-modules.git/monitoring/sns-email-topic"
  sns_emails = ["email1@asd.com", "email2@asd.com"]
}
```

## Inputs

You don't need to provide any inputs, but you can override all of the defaults. See the full list of inputs here: [variables.tf](./variables.tf)

## Outputs

[output.tf](./output.tf)
