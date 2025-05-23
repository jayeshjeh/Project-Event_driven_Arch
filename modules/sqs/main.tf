resource "aws_sqs_queue" "this" {
    name = var.queue_name
    delay_seconds = var.delay_seconds
    visibility_timeout_seconds = var.visibility_timeout
    message_retention_seconds = var.message_retention_seconds
    receive_wait_time_seconds = var.receive_wait_time_seconds

    tags = var.tags
}