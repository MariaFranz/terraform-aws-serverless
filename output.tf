output "api_url_trigger" {
    description = "URL to trigger"
    value = aws_apigatewayv2_stage.api_stage.invoke_url
}