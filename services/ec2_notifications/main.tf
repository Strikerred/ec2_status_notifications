locals {
  emails = ["fausto.gomez@clir.eco"]
}

resource "aws_sns_topic_subscription" "pfsense_ec2_target" {
  count     = length(local.emails)
  topic_arn = aws_sns_topic.pfsense_ec2_notifications.arn
  protocol  = "email"
  endpoint  = local.emails[count.index]
}

data "aws_caller_identity" "pfsense_account_id" {

}

data "aws_iam_policy_document" "pfsense_sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    sid    = "__default_statement_ID"
    effect = "Allow"

    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        data.aws_caller_identity.pfsense_account_id.account_id
      ]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [aws_sns_topic.pfsense_ec2_notifications.arn]

  }

  dynamic "statement" {
    for_each = var.event_names
    iterator = event_name

    content {
      sid = "AWSEvents_pfsense-${event_name.value}_${event_name.value}"

      effect = "Allow"
      principals {
        type        = "Service"
        identifiers = ["events.amazonaws.com"]
      }

      actions = [
        "sns:Publish"
      ]

      resources = [aws_sns_topic.pfsense_ec2_notifications.arn]
    }
  }
}

resource "aws_sns_topic" "pfsense_ec2_notifications" {
  name = "pfsense_ec2_notifications"
}

resource "aws_sns_topic_policy" "pfsense_topic_event_policy" {
  count  = length(var.event_names)
  arn    = aws_sns_topic.pfsense_ec2_notifications.arn
  policy = join("", data.aws_iam_policy_document.pfsense_sns_topic_policy[*].json)
}

resource "aws_cloudwatch_event_rule" "pfsense_ec2_alert_eventbridge_rule" {
  for_each      = toset(var.event_names)
  name          = "pfSense-${each.key}"
  description   = "This rule is to track and alert about pfSense Ec2 modifications"
  event_pattern = file("${path.module}/EventPatterns/${each.key}.json")
}

resource "aws_cloudwatch_event_target" "pfsense_ec2_status" {
  count     = length(var.event_names)
  rule      = element(values(aws_cloudwatch_event_rule.pfsense_ec2_alert_eventbridge_rule)[*].name, count.index)
  target_id = var.event_names[count.index]
  arn       = aws_sns_topic.pfsense_ec2_notifications.arn

  input_transformer {
    input_paths = jsondecode(file("${path.module}/InputTransformers/${(var.event_names[count.index])}.json"))

    input_template = file("${path.module}/InputTemplates/InputTemplate.txt")
  }
}

