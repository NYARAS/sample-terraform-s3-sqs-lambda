# Data resource to archive Lambda function code
data "archive_file" "lambda_zip" {
    source_dir  = "${path.module}/lambda/"
    output_path = "${path.module}/lambda.zip"
    type        = "zip"
}

# Lambda function policy
resource "aws_iam_policy" "lambda_policy" {
    name        = "${var.app_env}-lambda-policy"
    description = "${var.app_env}-lambda-policy"
 
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.bucket.arn}"
    },
    {
      "Action": [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ],
      "Effect": "Allow",
      "Resource": "${aws_sqs_queue.queue.arn}"
    },
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Lambda function role
resource "aws_iam_role" "iam_for_terraform_lambda" {
    name = "${var.app_env}-lambda-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Role to Policy attachment
resource "aws_iam_role_policy_attachment" "terraform_lambda_iam_policy_basic_execution" {
    role = aws_iam_role.iam_for_terraform_lambda.id
    policy_arn = aws_iam_policy.lambda_policy.arn
}


# Lambda function declaration
resource "aws_lambda_function" "sqs_processor" {
    filename = "lambda.zip"
    source_code_hash = data.archive_file.lambda_zip.output_base64sha256
    function_name = "${var.app_env}-lambda"
    role = aws_iam_role.iam_for_terraform_lambda.arn
    handler = "index.handler"
    runtime = "python3.8"
}
