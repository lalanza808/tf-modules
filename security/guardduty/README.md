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

Due to the way Terraform interfaces with Cloudformation Stack Set instances the module cannot apply resources in parallel - the stack set is busy. So the only limitation with this module is that you must run Terraform with the `-parellism=1` flag set.


## Inputs

You don't need to provide any inputs, but you can override all of the defaults.

* `prefix` - string
* `tags` - map `{"key": "value"}`

See the full list of inputs here: [variables.tf](./variables.tf)
