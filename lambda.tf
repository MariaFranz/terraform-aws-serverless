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

resource "aws_lambda_event_source_mapping" "receive" {
  event_source_arn = module.aws_sqs_queue.arn
  function_name    = aws_lambda_function.test_lambda.arn
}