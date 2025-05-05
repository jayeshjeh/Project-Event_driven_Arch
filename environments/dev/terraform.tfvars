region = "us-east-1"

vpc_cidr = "10.0.0.0/16"
public_subnets = [
  { cidr = "10.0.1.0/24", azs = "us-east-1a" },
  { cidr = "10.0.2.0/24", azs = "us-east-1b" }
]
private_subnets = [
  { cidr = "10.0.3.0/24", azs = "us-east-1a" },
  { cidr = "10.0.4.0/24", azs = "us-east-1b" }
]
env = "dev"

ingress_ports = [22, 80, 443]

queue_name                = "project-queue"
delay_seconds             = 0
visibility_timeout        = 30
message_retention_seconds = 84600
receive_wait_time_seconds = 0

name_prefix = "ci"

function_name  = "ci-event-processor"
handler        = "index.handler"
runtime        = "python3.11"
lambda_package = "../../lambda_src/lambda.zip"
environment_variables = {
  ENV = "dev"
}
batch_size = 5

tags = {
  Environment = "dev"
  Project     = "event-driven-architecture"
  Owner       = "jayeshjeh"
}

