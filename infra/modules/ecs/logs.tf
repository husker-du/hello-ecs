##############################################################
# Null label contexts
##############################################################
module "logs_context" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.ecs_task_context.context
  delimiter  = "/"
}

# CloudWatch Logs
resource "aws_cloudwatch_log_group" "ecs" {
  name              = module.logs_context.id
  retention_in_days = var.logs_retention_days
  tags              = module.logs_context.tags
}