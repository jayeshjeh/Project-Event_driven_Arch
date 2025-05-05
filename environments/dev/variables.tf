variable "region" {}

variable "vpc_cidr" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "env" {}

variable "ingress_ports" {}

variable "queue_name" {}

variable "delay_seconds" {}
variable "visibility_timeout" {}
variable "message_retention_seconds" {}
variable "receive_wait_time_seconds" {}

variable "name_prefix" {}

variable "function_name" {}
variable "runtime" {}
variable "handler" {}
variable "lambda_package" {}
variable "environment_variables" {}
variable "batch_size" {}

variable "tags" {}