# terraform-aws-ecs-fargate-scheduled-task
Terraform module to create AWS ECS Fargate Scheduled Task

## Terraform versions

Terraform 0.12. Pin module version to `~> v1.0`. Submit pull-requests to `master` branch.

## Usage

```hcl
module "ecs-fargate-scheduled-task" {
  source = "umotif-public/ecs-fargate-scheduled-task/aws"
  version = "~> 1.0.0"

  name_prefix = "test-scheduled-task"

  ecs_cluster_arn = aws_ecs_cluster.main.arn

  task_role_arn      = var.task_role_arn
  execution_role_arn = var.execution_role_arn

  event_target_task_definition_arn = var.event_target_task_definition_arn
  event_rule_schedule_expression   = "rate(1 minute)"
  event_target_subnets             = ["subnet-1","subnet-2"]
}
```

## Assumptions

Module is to be used with Terraform > 0.12.

## Examples

* [ECS Fargate Scheduled Task](https://github.com/umotif-public/terraform-aws-ecs-fargate-scheduled-task/tree/master/examples/core)

## Authors

Module managed by [Marcin Cuber](https://github.com/marcincuber) [LinkedIn](https://www.linkedin.com/in/marcincuber/).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6 |
| aws | >= 2.45 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.45 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ecs\_cluster\_arn | The ECS Cluster where the scheduled task will be running | `any` | n/a | yes |
| event\_rule\_description | The description of the rule. | `any` | `null` | no |
| event\_rule\_event\_pattern | (Required, if schedule\_expression isn't specified) Event pattern described a JSON object. See full documentation of CloudWatch Events and Event Patterns for details. | `any` | `null` | no |
| event\_rule\_is\_enabled | Whether the rule should be enabled. | `bool` | `true` | no |
| event\_rule\_name | The rule's name. | `string` | `""` | no |
| event\_rule\_role\_arn | The Amazon Resource Name (ARN) associated with the role that is used for target invocation. | `any` | `null` | no |
| event\_rule\_schedule\_expression | (Required, if event\_pattern isn't specified) The scheduling expression. For example, cron(0 20 \* \* ? \*) or rate(5 minutes). | `any` | `null` | no |
| event\_target\_assign\_public\_ip | Assign a public IP address to the ENI (Fargate launch type only). Valid values are true or false. Default false. | `bool` | `false` | no |
| event\_target\_group | Specifies an ECS task group for the task. The maximum length is 255 characters. | `any` | `null` | no |
| event\_target\_id | The unique target assignment ID. If missing, will generate a random, unique id. | `any` | `null` | no |
| event\_target\_input | Valid JSON text passed to the target. | `any` | `null` | no |
| event\_target\_input\_path | The value of the JSONPath that is used for extracting part of the matched event when passing it to the target. | `any` | `null` | no |
| event\_target\_platform\_version | Specifies the platform version for the task. Specify only the numeric portion of the platform version, such as 1.1.0. This is used only if LaunchType is FARGATE. For more information about valid platform versions, see AWS Fargate Platform Versions. Default to LATEST | `string` | `"LATEST"` | no |
| event\_target\_security\_groups | The security groups associated with the task or service. If you do not specify a security group, the default security group for the VPC is used. | `list` | `[]` | no |
| event\_target\_subnets | The subnets associated with the task or service. | `list` | n/a | yes |
| event\_target\_task\_count | The number of tasks to create based on the TaskDefinition. The default is 1. | `number` | `1` | no |
| event\_target\_task\_definition\_arn | The ARN of the task definition to use if the event target is an Amazon ECS cluster. | `any` | n/a | yes |
| execution\_role\_arn | ARN of IAM Role for task execution (see: https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task_execution_IAM_role.html ) | `string` | `""` | no |
| name\_prefix | Name prefix for resources on AWS. | `any` | n/a | yes |
| tags | A map of tags (key-value pairs) passed to resources. | `map(string)` | `{}` | no |
| task\_role\_arn | ARN of IAM Role for task (see: https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task-iam-roles.html ) | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws\_cloudwatch\_event\_rule\_event\_rule\_arn | The Amazon Resource Name (ARN) of the CloudWatch Event Rule. |
| aws\_iam\_role\_policy\_id | The role policy ID, in the form of role\_name:role\_policy\_name. |
| aws\_iam\_role\_policy\_name | The name of the policy. |
| aws\_iam\_role\_policy\_role | The name of the role associated with the policy. |
| event\_role\_arn | The Amazon Resource Name (ARN) specifying the role. |
| event\_role\_create\_date | The creation date of the IAM role. |
| event\_role\_description | The description of the role. |
| event\_role\_id | The name of the role. |
| event\_role\_name | The name of the role. |
| event\_role\_unique\_id | The stable and unique string identifying the role. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

See LICENSE for full details.

## Pre-commit hooks

### Install dependencies

* [`pre-commit`](https://pre-commit.com/#install)
* [`terraform-docs`](https://github.com/segmentio/terraform-docs) required for `terraform_docs` hooks.
* [`TFLint`](https://github.com/terraform-linters/tflint) required for `terraform_tflint` hook.

#### MacOS

```bash
brew install pre-commit terraform-docs tflint

brew tap git-chglog/git-chglog
brew install git-chglog
```
