provider "aws" {
  region = var.location
}

module "aws_sqs_queue" {
  source = "./sqs"
}
