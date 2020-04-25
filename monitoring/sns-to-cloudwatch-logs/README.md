# SNS to Cloudwatch Logs

This module creates an SNS topic with Lambda subscription and Cloudwatch Log groups. When messages are published to the SNS topic the Lambda function transforms the event message into a JSON object and pushes the event into a Cloudwatch Log stream.

This is useful in some cases where an AWS service only has an SNS topic option (like Guard Duty) but you want to export logs to other services (like Datadog).

The Python script found under `./lambda` is zipped up via the `archive_file` Terraform data type and stored onto S3 via `aws_s3_bucket_object` Terraform resource.

## Usage

```
module "sns" {
  source = "github.com/lalanza808/tf-modules.git/monitoring/sns-to-cloudwatch-logs"

  namespace = "sandbox-guardduty"
}
```

## Inputs

`namespace` is the only input. All the resources get named with this variable.

## Outputs

You will want to reference the outputs to retrieve the SNS topic ARN; many other modules will want to use it as an input to another module. See [output.tf](./output.tf) for full details.
