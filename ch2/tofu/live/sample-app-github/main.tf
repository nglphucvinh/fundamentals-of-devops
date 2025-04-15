provider "aws" {
  region = "us-east-2"
}

module "sample_app_1" {
  source  = "github.com/nglphucvinh/fundamentals-of-devops//ch2/tofu/modules/ec2-instance?ref=0.0.1"

  name = "sample-app-tofu-1"

}

module "sample_app_2" {
  source = "github.com/nglphucvinh/fundamentals-of-devops//ch2/tofu/modules/ec2-instance?ref=0.0.1"

  name = "sample-app-tofu-2"
}
