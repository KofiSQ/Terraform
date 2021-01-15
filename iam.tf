resource "aws_iam_role_policy" "lambda_policy" {
  provider    = aws.region-prod
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id

  policy = file("lambda-policy.json")
}

resource "aws_iam_role" "lambda_role" {
  provider    = aws.region-prod
  name = "lambda_role"
  assume_role_policy = file("lambda-assume-policy.json")
 
}
