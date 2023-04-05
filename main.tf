provider "aws" {
  region = var.location
}

module "aws_sqs_queue" {
  source = "./sqs"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda.py"
  output_path = "lambda.zip"
}

resource "aws_lambda_function" "test_lambda" {

  filename      = data.archive_file.lambda.output_path
  function_name = "lambda_function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.8"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_sqs_role_policy" {
  role       = resource.aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_role_policy_attachment" "basic" {
  role       = resource.aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_event_source_mapping" "receive" {
  event_source_arn = module.aws_sqs_queue.arn
  function_name    = aws_lambda_function.test_lambda.arn
}

resource "aws_lambda_function" "trigger_sqs" {

  filename      = data.archive_file.lambda.output_path
  function_name = "lambda_function_trigger"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda.lambda_trigger"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.8"

  environment {
    variables = {
      sqs_url = module.aws_sqs_queue.url
    }
  }
}
