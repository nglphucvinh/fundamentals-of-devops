terraform {
  backend "s3" {
    bucket         = "vnguyen-fundamentals-of-devops-tofu-state"
    key            = "ch5/tofu/live/lambda-sample/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "vnguyen-fundamentals-of-devops-tofu-state"
  }
}