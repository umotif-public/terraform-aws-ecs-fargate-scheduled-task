provider "aws" {
  region = "eu-west-1"
}

#####
# VPC and subnets
#####
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.21"

  name = "simple-vpc"

  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
}

resource "aws_ecs_cluster" "main" {
  name = "test-cluster"
}

module "ecs-task-definition" {
  source  = "umotif-public/ecs-fargate-task-definition/aws"
  version = "1.0.0"

  enabled              = true
  name_prefix          = "test-container"
  task_container_image = "httpd:2.4"

  container_name      = "test-container-name"
  task_container_port = "80"
  task_host_port      = "80"
}

module "ecs-scheduled-task" {
  source = "../.."

  name_prefix = "test-scheduled-task"

  ecs_cluster_arn = aws_ecs_cluster.main.arn

  task_role_arn      = module.ecs-task-definition.task_role_arn
  execution_role_arn = module.ecs-task-definition.execution_role_arn

  event_target_task_definition_arn = module.ecs-task-definition.task_definition_arn
  event_rule_schedule_expression   = "rate(1 minute)"
  event_target_subnets             = module.vpc.public_subnets
}
