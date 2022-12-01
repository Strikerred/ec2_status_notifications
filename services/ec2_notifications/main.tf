locals {
  emails      = ["faustogomez2019@gmail.com"]
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

data "template_file" "this" {
  for_each = toset(local.event_names)
  template = file("${path.module}/EventPatterns/${each.key}.tpl")

  vars = {
    instance_id          = join(", ", [for s in var.instance_id : format("%q", s)])
    security_group_id    = join(", ", [for s in var.security_group_id : format("%q", s)])
    eni_attachment_id    = join(", ", [for s in var.eni_attachment_id : format("%q", s)])
    network_interface_id = join(", ", [for s in var.network_interface_id : format("%q", s)])
    eip_association_id   = join(", ", [for s in var.eip_association_id : format("%q", s)])
  }
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
  count         = length(local.event_names)
  name          = "pfSense-${element(local.event_names, count.index)}"
  description   = "This rule is to track and alert about pfSense Ec2 modifications"
  event_pattern = element(values(data.template_file.this)[*].rendered, count.index)
}

resource "aws_cloudwatch_event_target" "this" {
  for_each  = toset(local.event_names)
  rule      = "pfSense-${each.key}"
  target_id = "pfSense-${each.key}"
  arn       = aws_sns_topic.this.arn

  input_transformer {
    input_paths = jsondecode(file("${path.module}/InputTransformers/${each.key}.json"))

    input_template = file("${path.module}/InputTemplates/InputTemplate.txt")
  }
}
