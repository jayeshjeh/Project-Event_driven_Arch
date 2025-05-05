output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}


output "security_group_id" {
  value = module.security_group.security_group_id
}


output "sqs_queue_url" {

  value = module.sqs.queue_url
}

output "sqs_queue_arn" {
  value = module.sqs.queue_arn
}


output "lambda_role_arn" {

  value = module.iam.lambda_role_arn
}

output "github_actions_role_arn" {
  description = "The ARN of the GitHub Actions OIDC role"
  value       = aws_iam_role.github_actions.arn
}


output "lambda_function_arn" {
  value = module.lambda.lambda_function_arn
}

output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}


output "event_mapping_id" {
  value = module.event_mapping.event_mapping_id
}

output "github_oidc_provider_arn" {

  value = aws_iam_openid_connect_provider.github.arn
}