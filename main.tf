# Data resource to archive Lambda function code
data "archive_file" "lambda_zip" {
    source_dir  = "${path.module}/lambda/"
    output_path = "${path.module}/lambda.zip"
    type        = "zip"
}
