resource "aws_sns_topic" "pfsense_ec2_notifications" {
  name = "pfsense_ec2_notifications"
}

resource "aws_sns_topic_subscription" "pfsense_ec2_target" {
  topic_arn = aws_sns_topic.pfsense_ec2_notifications.arn
  protocol  = "email"
  endpoint  = "fausto.gomez@clir.eco"
}

resource "aws_cloudwatch_event_rule" "ec2_alert_eventbridge_rule" {
  for_each      = toset(var.event_names)
  name          = "pfSense-${each.key}"
  description   = "This rule is to track and alert about pfSense Ec2 modifications"
  event_pattern = file("${path.module}/EventPatterns/${each.key}.json")
}

resource "aws_cloudwatch_event_target" "ec2_status" {
  count     = length(var.event_names)
  rule      = element(values(aws_cloudwatch_event_rule.ec2_alert_eventbridge_rule)[*].name, count.index)
  target_id = var.event_names[count.index]
  arn       = aws_sns_topic.pfsense_ec2_notifications.arn

  input_transformer {
    input_paths = jsondecode(file("${path.module}/InputTransformers/${(var.event_names[count.index])}.json"))

    input_template = file("${path.module}/InputTemplates/InputTemplate.txt")
  }
}

