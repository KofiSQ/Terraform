locals {
	lambda_zip_location = "outputs/welcome.zip"
}

data "archive_file" "welcome" {
  type        = "zip"
  source_file = "welcome.py"
  output_path = "local.lambda_zip_location"
}
resource "aws_lambda_function" "prod_lambda" {
    provider         = aws.region-prod
    filename         = "local.lambda_zip_location"
    role             = aws_iam_role.lambda_role.arn
    function_name    = "welcome"
    handler          = "welcome.hello"
    runtime          = "python3.7"
}

#source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"