##############################################################
# Null label contexts
##############################################################
module "ecs_cluster_context" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.this.context
  attributes = ["hello-world" ,"cluster"]
}

module "ecs_task_context" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.ecs_cluster_context.context
  attributes = ["task"]
}

module "ecs_task_execution_context" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.ecs_task_context.context
  attributes = ["execution"]
}

module "ecs_service_context" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.ecs_cluster_context.context
  attributes = ["service"]
}


##############################################################
# ECS cluster
##############################################################
resource "aws_ecs_cluster" "hello_world" {
  name = module.ecs_cluster_context.id
  tags = module.ecs_cluster_context.tags
}

# ECS Task Definition
resource "aws_ecs_task_definition" "hello_world" {
  family                   = module.ecs_task_context.id
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name      = module.ecs_task_context.id
    image     = var.docker_image
    cpu       = var.task_cpu
    memory    = var.task_memory
    essential = true
    portMappings = [{
      containerPort = var.app_port
      hostPort      = var.app_port
      protocol      = "tcp"
    }]
    environment = [
      { name = "NODE_ENV", value = var.node_env },
      { name = "PORT", value = tostring(var.app_port) }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
        "awslogs-region"        = var.region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])

  tags = module.ecs_task_context.tags
}

# ECS Service
resource "aws_ecs_service" "hello_world" {
  name            = module.ecs_service_context.id
  cluster         = aws_ecs_cluster.hello_world.id
  task_definition = aws_ecs_task_definition.hello_world.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_task.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb.arn
    container_name   = module.ecs_task_context.id
    container_port   = var.app_port
  }

  depends_on = [aws_lb_listener.http]

  tags = module.ecs_service_context.tags
}

##############################################################
# Security groups
##############################################################
resource "aws_security_group" "ecs_task" {
  name        = module.ecs_task_context.id
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  tags = module.ecs_task_context.tags
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ecs_task.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Allow ALB to access ECS
resource "aws_security_group_rule" "alb_to_ecs" {
  type                     = "ingress"
  from_port                = var.app_port
  to_port                  = var.app_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs_task.id
  source_security_group_id = aws_security_group.alb.id
}