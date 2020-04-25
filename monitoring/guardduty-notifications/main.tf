resource "aws_cloudwatch_event_rule" "guardduty" {
  name        = "${var.prefix}-guardduty"
  description = "Capture AWS Guard Duty findings and notify operations"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.guardduty"
  ],
  "detail-type": [
    "GuardDuty Finding"
  ]
}
PATTERN

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "guardduty" {
  name              = "/aws/events/${var.prefix}-guardduty"
  retention_in_days = var.log_retention
}

resource "aws_cloudwatch_event_target" "guardduty-sns" {
  rule      = aws_cloudwatch_event_rule.guardduty.name
  target_id = "send_to_sns"
  arn       = var.sns_topic_arn
}

resource "aws_cloudwatch_event_target" "guardduty-cwlogs" {
  rule      = aws_cloudwatch_event_rule.guardduty.name
  target_id = "send_to_cloudwatch_logs"
  arn       = aws_cloudwatch_log_group.guardduty.arn
}
