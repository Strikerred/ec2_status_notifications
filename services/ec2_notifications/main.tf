locals {
  emails      = ["fausto.gomez@clir.eco"]
  event_names = ["AssociateAddress-AttachNetworkInterface", "AssociateIamInstanceProfile", "DetachNetworkInterface", "DisassociateAddress", "DisassociateIamInstanceProfile", "InstanceStatus", "ModifyNetworkInterfaceAttribute", "SecurityGroupIngress"]
}

resource "aws_sns_topic_subscription" "this" {
  count     = length(local.emails)
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = local.emails[count.index]
}

data "aws_caller_identity" "this" {

}

resource "aws_sns_topic" "this" {
  name = "pfsense_ec2_notifications"
}

resource "aws_sns_topic_policy" "this" {
  count  = length(local.event_names)
  arn    = aws_sns_topic.this.arn
  policy = join("", data.aws_iam_policy_document.pfsense_sns_topic_policy[*].json)
}

resource "aws_cloudwatch_event_rule" "pfSense_ec2_alert_eventbridge_rule" {
  for_each      = toset(local.event_names)
  name          = "pfSense-${each.key}"
  description   = "This rule is to track and alert about pfSense Ec2 modifications"
  event_pattern = file("${path.module}/EventPatterns/${each.key}.json")
}

resource "aws_cloudwatch_event_target" "this" {
  count     = length(local.event_names)
  rule      = element(values(aws_cloudwatch_event_rule.pfSense_ec2_alert_eventbridge_rule)[*].name, count.index)
  target_id = local.event_names[count.index]
  arn       = aws_sns_topic.this.arn

  input_transformer {
    input_paths = jsondecode(file("${path.module}/InputTransformers/${(local.event_names[count.index])}.json"))

    input_template = file("${path.module}/InputTemplates/InputTemplate.txt")
  }
}

