# Organizations

This module sets up the foundation of an AWS account playing the role of "Master Payer"; the parent organization in the AWS Organizations service. This module will manage the parent Organization's service along with subordinate Organizational Units (OU), policies, and policy attachments.

This module explicitly does not setup the AWS accounts; it will setup the backend Organizations service and cost and usage reporting only and should be referenced by additional templates for provisioning accounts.

Only use this module on a standalone AWS account that is not already a member of an Organization.

## Usage

```
module "master_payer" {
  source = "github.com/lalanza808/tf-modules.git/organizations/aws-master"
}

module "sandbox-account" {
  source = "github.com/lalanza808/tf-modules.git/organizations/subaccount"

  account_name   = "sandbox"
  account_email  = "root+sandbox@domain.com"
  parent_ou_id   = module.master_payer.prod_ou_id
}

output "sandbox-account" {
  value = module.sandbox-account.account_id
}
```

## Inputs

See the full list of inputs here: [variables.tf](./variables.tf)

## Outputs

[output.tf](./output.tf)
