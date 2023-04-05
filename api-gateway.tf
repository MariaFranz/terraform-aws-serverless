resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "example-http-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "example" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.trigger_sqs.invoke_arn
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_route" "api_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "ANY /trigger_sqs"
  target    = "integrations/${aws_apigatewayv2_integration.example.id}"
}

resource "aws_lambda_permission" "api" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.trigger_sqs.function_name
  principal     = "apigateway.amazonaws.com"
}

