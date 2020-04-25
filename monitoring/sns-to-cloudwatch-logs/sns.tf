resource "aws_sns_topic" "this" {
  name = var.namespace
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn            = aws_sns_topic.this.arn
  protocol             = "lambda"
  endpoint             = aws_lambda_function.lambda.arn
  raw_message_delivery = false
}

resource "aws_sns_topic_policy" "this" {
  arn    = aws_sns_topic.this.arn
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "AllowAccountNotifications",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:Publish",
        "SNS:RemovePermission",
        "SNS:SetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:Receive",
        "SNS:AddPermission",
        "SNS:Subscribe"
      ],
      "Resource": "${aws_sns_topic.this.arn}",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${local.account_id}"
        }
      }
    },
    {
      "Sid": "AllowBackupNotifications",
      "Effect": "Allow",
      "Principal": {
        "Service": "backup.amazonaws.com"
      },
      "Action": "SNS:Publish",
      "Resource": "${aws_sns_topic.this.arn}"
    }
  ]
}
EOF
}
