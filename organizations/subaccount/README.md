# aws-master - accounts

This module sets up a subordinate AWS account under a given organization. You need to use it in conjunction with the `aws-master/organizations` module to setup the Organizations backend on a master payer account.

Only use this module on the "Master Payer" AWS account.

*This has not been tested yet and will not work*.

## Usage

```
module "master_payer" {
  source = "github.com/lalanza808/tf-modules.git/organizations/suborganizations"

  prefix = module.labels.id
  tags   = module.labels.tags

  enable_cur = true # cost and usage reporting to S3
  enable_org = true # enables organizations service
}

module "aws_account_sandbox" "sandbox" {
  source = "github.com/lalanza808/tf-modules.git/organizations/subaccounts"

  account_name   = "sandbox"
  account_email  = "aws-admin+sandbox@corp.com"
  parent_ou_id   = module.master_payer.prod_ou_id
}

output "sandbox_account_id" {
  value = module.aws_account_sandbox.sandbox.account_id
}
```

## Inputs


You need to specify the following:

* `parent_ou_id`
* `account_name`
* `account_email`

See the full list of inputs here: [variables.tf](./variables.tf)

## Outputs

* `account_id`
* `account_arn`

[output.tf](./output.tf)
