resource "aws_cloudwatch_event_rule" "health" {
  name        = "${var.prefix}-aws-health"
  description = "Capture AWS Health events and notify operations"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.health"
  ]
}
PATTERN

  tags = {
    Terraform = "True"
  }
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.health.name
  target_id = "${var.prefix}-aws-health"
  arn       = var.sns_topic_arn
}
