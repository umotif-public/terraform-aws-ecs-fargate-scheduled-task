#####
# Cloudwatch event IAM Role
#####
resource "aws_iam_role" "scheduled_task_event_role" {
  name = "${var.name_prefix}-task-event-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = var.tags
}

resource "aws_iam_role_policy" "scheduled_task_event_role_policy" {
  name   = "${var.name_prefix}-task-event-role-policy"
  role   = aws_iam_role.scheduled_task_event_role.id
  policy = data.aws_iam_policy_document.scheduled_task_event_role_policy_document.json
}

#####
# Cloudwatch event rule and target
#####
resource "aws_cloudwatch_event_rule" "event_rule" {
  name                = var.event_rule_name == "" ? "${var.name_prefix}-rule" : var.event_rule_name
  description         = var.event_rule_description
  schedule_expression = var.event_rule_schedule_expression
  event_pattern       = var.event_rule_event_pattern
  role_arn            = var.event_rule_role_arn
  is_enabled          = var.event_rule_is_enabled

  tags = merge(
    var.tags,
    {
      Name = var.event_rule_name == "" ? "${var.name_prefix}-rule" : var.event_rule_name
    }
  )
}

resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  rule = aws_cloudwatch_event_rule.event_rule.name

  target_id  = var.event_target_id
  arn        = var.ecs_cluster_arn
  input      = var.event_target_input
  input_path = var.event_target_input_path
  role_arn   = aws_iam_role.scheduled_task_event_role.arn

  ecs_target {
    task_definition_arn = var.event_target_task_definition_arn
    task_count          = var.event_target_task_count
    platform_version    = var.event_target_platform_version
    launch_type         = "FARGATE"
    group               = var.event_target_group

    network_configuration {
      subnets          = var.event_target_subnets
      security_groups  = var.event_target_security_groups
      assign_public_ip = var.event_target_assign_public_ip
    }
  }
}
