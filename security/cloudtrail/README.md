# Cloudtrail

Configure AWS Cloudtrail in a given AWS account. Logs all S3 bucket data plane operations by default; see inputs for more info.

https://aws.amazon.com/cloudtrail/

## Usage

```
module "cloudtrail" {
  source = "github.com/lalanza808/tf-modules.git/security/cloudtrail"
}
```

## Inputs

There are a few variables that can be tweaked here. You can also override the default behavior of logging all S3 bucket data plane operations to either log nothing or log some buckets.

* `default_log_bucket` - set to empty string to remove all bucket logging
* `activity_log_buckets` - list of bucket names to setup extra logging for

See the full list of inputs here: [variables.tf](./variables.tf)

## Outputs

[output.tf](./output.tf)
