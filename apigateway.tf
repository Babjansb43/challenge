# Create API Gateway
# AWS HTTP API Gateway
resource "aws_apigatewayv2_api" "my_api" {
  name          = "MyHTTPAPI"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.my_api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.hello_world_lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "my_route" {
  api_id    = aws_apigatewayv2_api.my_api.id
  route_key = "$default"

  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# AWS HTTP API Stage
resource "aws_apigatewayv2_stage" "my_stage" {
  api_id      = aws_apigatewayv2_api.my_api.id
  name        = "prod"  # Specify the desired stage name
  auto_deploy = true
}
resource "aws_cloudfront_distribution" "api_gateway_distribution" {
  origin {
    domain_name = "bo6udwwkpe.execute-api.eu-north-1.amazonaws.com" 
    origin_id   = "api_gateway_origin"
    origin_path = "/prod"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "API Gateway HTTP CloudFront Distribution"
  default_root_object = ""

  web_acl_id          = aws_wafv2_web_acl.my_web_acl.id   

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "DELETE", "PATCH"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "api_gateway_origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Additional settings, like SSL configuration, can be added as needed
}


