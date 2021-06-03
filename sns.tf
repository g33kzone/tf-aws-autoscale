resource "aws_sns_topic" "mrw_web_app_sns_topic" {
  name         = "mrw-web-app-sns-topic"
  display_name = "web-app-notification"
}

resource "aws_sns_topic_subscription" "mrw_web_app_sns_subscription" {
  topic_arn = aws_sns_topic.mrw_web_app_sns_topic.arn
  protocol  = "email-json"
  endpoint  = var.sns_topic_email
}