# KMS Key

This module sets up a new KMS key and alias with the required policy for allowing certain roles to access the KMS key to encrypt/decrypt secrets.

This can be used by any workloads which need encryption keys with KMS.

## Usage

This module is intended to be used in conjunction with other IAM related modules for each application. You must provide the `app_name` and `usage_roles` inputs in order to have access for any applications or tools which use SSM.

`app_name` becomes the KMS key alias and `usage_roles` is a list of IAM roles which can have basic access to decrypt secrets with the key.

```
module "my-new-app-kms" {
  source              = "github.com/lalanza808/tf-modules.git/security/kms-key"
  app_name            = "my-new-app"
  usage_roles         = ["app_iam_role"]
  administrator_roles = ["administrator"]
}
```

The outputs can be used as references for other tools and systems.

## Inputs

See all inputs in [variables](./variables.tf)
