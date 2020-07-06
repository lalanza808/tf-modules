resource "aws_cloudwatch_event_rule" "health" {
  name        = "${var.prefix}-aws-securityhub"
  description = "Capture AWS SecurityHub incidents and notify operations SNS"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.securityhub"
  ],
  "detail-type": [
    "Security Hub Findings - Imported"
  ]
}
PATTERN

  tags = {
    Terraform = "True"
  }
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.health.name
  target_id = "${var.prefix}-aws-securityhub"
  arn       = var.sns_topic_arn
}
