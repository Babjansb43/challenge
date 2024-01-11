# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Role Policy for Lambda Execution
resource "aws_iam_role_policy" "lambda_execution_policy" {
  name = "lambda_execution_policy"
  role = aws_iam_role.lambda_execution_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action   = "logs:*",
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Attach policies to Lambda Execution Role (if needed)
resource "aws_iam_role_policy_attachment" "lambda_execution_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_execution_role.name
}