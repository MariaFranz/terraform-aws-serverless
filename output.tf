output "api_url_trigger" {
    description = "URL to trigger"
    value = module.aws_sqs_queue.url
}