output "lambda_function_arn" {
  value = aws_lambda_function.auto_observability.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.auto_observability.function_name
}
