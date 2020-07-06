resource "aws_accessanalyzer_analyzer" "example" {
  analyzer_name = var.name
  tags = var.tags
}
