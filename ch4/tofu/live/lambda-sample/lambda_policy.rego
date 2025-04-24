package terraform

deny contains msg if {
  resource := input.resource.aws_lambda_function[_]
  resource.timeout >= 30
  msg := "Lambda functions must have a timeout less than 30 seconds"
}

deny contains msg if {
  resource := input.resource.aws_lambda_function[_]
  not resource.environment.variables.NODE_ENV
  msg := "Lambda functions must have NODE_ENV environment variable"
}