resource "aws_iam_role" "lambda" {
  name_prefix = "${var.namespace}-lambda-"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "lambda" {
  name = aws_iam_role.lambda.name
  role = aws_iam_role.lambda.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_cloudwatch_log_group.lambda.arn}",
        "${aws_cloudwatch_log_group.logs.arn}"
      ]
    }
  ]
}
POLICY
}
