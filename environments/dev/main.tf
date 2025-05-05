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