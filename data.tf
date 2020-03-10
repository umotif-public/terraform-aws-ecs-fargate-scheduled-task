
data "aws_iam_policy_document" "scheduled_task_event_role_policy_document" {
  statement {
    sid    = "AllowECSRunTask"
    effect = "Allow"

    actions = ["ecs:RunTask"]

    resources = ["*"]
  }

  statement {
    sid    = "AllowIAMPassRole"
    effect = "Allow"

    actions = ["iam:PassRole"]

    resources = var.execution_role_arn == "" ? [var.task_role_arn] : [var.task_role_arn, var.execution_role_arn]
  }
}
