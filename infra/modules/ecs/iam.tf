##############################################################
# Task execution role
##############################################################
resource "aws_iam_role" "ecs_task_execution_role" {
  name = module.ecs_task_execution_context.id

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  tags = module.ecs_task_execution_context.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


##############################################################
# Task role
##############################################################
resource "aws_iam_role" "ecs_task_role" {
  name = module.ecs_task_context.id

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  tags = module.ecs_task_context.tags
}