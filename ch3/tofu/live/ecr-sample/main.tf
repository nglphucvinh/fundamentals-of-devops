provider "aws" {
  region = "us-east-2"
}

module "repo" {
  source  = "../../modules/ecr-repo"

  name = "sample-app"
}