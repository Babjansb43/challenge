# Create Lambda Function
resource "aws_lambda_function" "hello_world_lambda" {
  function_name = "helloworld"
  runtime       = "python3.8"
  handler       = "hello.handler"
  role          = aws_iam_role.lambda_execution_role.arn
  filename      = "my_lambda_function.zip" # Path to your Lambda function code
  vpc_config {
    subnet_ids         = [aws_subnet.private_subnet.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  tags = {
    Name = "hello_world_lambda"
  }
}