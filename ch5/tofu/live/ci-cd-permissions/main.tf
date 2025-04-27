provider "aws" {
  region = "us-east-2"
}

module "oidc_provider" {
  source  = "../../modules/github-aws-oidc"

  provider_url = "https://token.actions.githubusercontent.com" 
}

module "iam_roles" {
  source  = "../../modules/gh-actions-iam-roles"
  name              = "lambda-sample"                           
  oidc_provider_arn = module.oidc_provider.oidc_provider_arn    

  enable_iam_role_for_testing = true          

  enable_iam_role_for_plan  = true  # Add for GitHub Action deployment                             
  enable_iam_role_for_apply = true  # Add for GitHub Action deployment

  github_repo      = "nglphucvinh/fundamentals-of-devops" 
  lambda_base_name = "lambda-sample"                            
}