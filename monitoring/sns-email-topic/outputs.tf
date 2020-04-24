output "topic_arn" {
  value = aws_cloudformation_stack.sns_stack.outputs["TopicARN"]
}
