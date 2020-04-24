# Guard Duty

This modules sets up Guard Duty in the given regions.

https://aws.amazon.com/guardduty/

## Usage

```
module "guardduty" {
  source = "github.com/lalanza808/tf-modules.git/security/guardduty/"
}
```

## Inputs

You don't need to provide any inputs, but you can override all of the defaults.

* `prefix` - string
* `tags` - map `{"key": "value"}`

See the full list of inputs here: [variables.tf](./variables.tf)
