# Guard Duty

This modules sets up Guard Duty in specific AWS regions (all, by default).

https://aws.amazon.com/guardduty/

Guard Duty is setup per-region which means for a Terraform project you need to specify providers for all regions and source a given module for each region. This module uses Cloudformation Stack Sets under the hood to simplify the deployment so that one module sourcing can provision Guard Duty in all regions.

## Usage

```
module "guardduty" {
  source = "github.com/lalanza808/tf-modules.git/security/guardduty/"
}
```

## Limitations

### Lack of Parallelism

Due to the way Terraform interfaces with Cloudformation Stack Set instances the module cannot apply resources in parallel - the stack set is busy. So the only limitation with this module is that you must run Terraform with the `-parellism=1` flag set.

### Deletion

If you want to remove the module in it's entirety, you can't use `terraform destroy` because of the way Cloudformation Stack Sets works - it needs a certain IAM role to orchestrate the removal of the Stack Set instances and a destroy operation will delete that role, preventing the removal of the remainder of resources.

Instead, set the `regions` to an empty list: `[]`


## Inputs

You don't need to provide any inputs, but you can override all of the defaults.

* `prefix` - string
* `tags` - map `{"key": "value"}`

See the full list of inputs here: [variables.tf](./variables.tf)
