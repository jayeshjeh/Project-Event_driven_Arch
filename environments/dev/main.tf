provider "aws" {
  region = var.region

}

terraform {
  backend "s3" {
    bucket       = "projbucket898"
    key          = "dev/terraform.tfstate"
    use_lockfile = true
    region       = "us-east-1"
  }
}


module "vpc" {
  source          = "../../modules/vpc"
  cidr_block      = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  env             = "dev"
}

module "security_group" {
  source        = "../../modules/sg"
  vpc_id        = module.vpc.vpc_id
  env           = var.env
  ingress_ports = var.ingress_ports
}

module "sqs" {
  source                    = "../../modules/sqs"
  queue_name                = var.queue_name
  delay_seconds             = var.delay_seconds
  visibility_timeout        = var.visibility_timeout
  message_retention_seconds = var.message_retention_seconds
  receive_wait_time_seconds = var.receive_wait_time_seconds
  tags                      = var.tags

}

module "iam" {
  source         = "../../modules/iam"
  name_prefix    = var.name_prefix
  sqs_queue_arns = [module.sqs.queue_arn]
  region         = var.region
}

module "lambda" {
  source                = "../../modules/lambda"
  function_name         = var.function_name
  lambda_role_arn       = module.lambda_role_arn
  runtime               = var.runtime
  handler               = var.handler
  lambda_package        = var.lambda_package
  environment_variables = var.environment_variables
  tags                  = var.tags
}

module "event_mapping" {
  source              = "../../modules/event_mapping"
  lambda_function_arn = module.lambda_function_arn
  sqs_queue_arn       = module.sqs_queue_arn
  batch_size          = var.batch_size
  depends_on_lambda   = module.lambda_function_arn
  depends_on_sqs      = module.sqs_queue_arn
}


# OIDC
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"  # GitHub's OIDC thumbprint
  ]
}

# IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions" {
  name = "${var.name_prefix}-github-oidc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          },
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:jayeshjeh/Project-Event_driven_Arch:ref:refs/heads/main"

          }
        }
      }
    ]
  })

  tags = var.tags
}

# Attach policy to allow Terraform operations
resource "aws_iam_role_policy_attachment" "github_terraform_attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"  
}