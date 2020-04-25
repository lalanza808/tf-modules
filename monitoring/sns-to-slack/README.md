Use a community module for this one. I use this one: https://github.com/terraform-aws-modules/terraform-aws-notify-slack

```
module "slack_webhook" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "~> 2.0"

  sns_topic_name    = module.sns-notifs.topic_name
  slack_webhook_url = "https://hooks.slack.com/services/xxx/yyy/zzz"
  slack_channel     = "ops"
  slack_username    = "AWS Ops"
}
```
