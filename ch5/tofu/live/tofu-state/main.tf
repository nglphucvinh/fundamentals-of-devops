provider "aws" {
  region = "us-east-2"
}

module "state" {
  source  = "../../modules/state-bucket"
  name = "vnguyen-fundamentals-of-devops-tofu-state"
}