resource "aws_lambda_function" "lambda_function" {
  function_name = "ResumeCounterLambda"

  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
  handler          = "index.lambda_handler"  # Update this based on your Lambda function's handler
  runtime          = "python3.8"             # Update this based on your Lambda function's runtime

  role = aws_iam_role.lambda_iam_role.arn
}

resource "aws_iam_role" "lambda_iam_role" {
  name = "lambda_iam_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "lambda_dynamodb_access" {
  role = aws_iam_role.lambda_iam_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:UpdateItem"
        ],
        Effect = "Allow",
        Resource = "arn:aws:dynamodb:*:*:table/cloudresumechallenge-viewcounter"
      }
    ]
  })
}
