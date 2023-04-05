resource "aws_sqs_queue" "terraform_queue" {
  name                      = var.name
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = var.redrive_policy

  tags = {
    Environment = "test"
  }
}