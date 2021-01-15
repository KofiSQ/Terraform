resource "aws_sqs_queue" "results_updates_dl_queue" {
    provider = aws.region-prod
    name = "results-updates-dl-queue"
}
resource "aws_sqs_queue" "prod_queue" {
  provider                  = aws.region-prod
  name                      = "prod-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy  = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.results_updates_dl_queue.arn}\",\"maxReceiveCount\":5}"

  tags = {
    Environment = "production"
  }
}
