output "lambda_test_role_arn" {
  description = "The ARN of the IAM role for testing"
  value       = module.iam_roles.lambda_test_role_arn
}