data "template_file" "endpoints" {
  template = file("${path.module}/files/email-endpoint-list.json.tpl")
  count    = length(var.sns_emails)

  vars = {
    email_address = element(var.sns_emails, count.index)
  }
}

data "template_file" "sns_stack" {
  template = file("${path.module}/files/email-sns-stack.json.tpl")

  vars = {
    endpoints    = join(",", data.template_file.endpoints.*.rendered)
    display_name = "${var.prefix}-sns-email"
  }
}

resource "aws_cloudformation_stack" "sns_stack" {
  name          = "${var.prefix}-sns-email"
  template_body = data.template_file.sns_stack.rendered
  tags          = var.tags
}
