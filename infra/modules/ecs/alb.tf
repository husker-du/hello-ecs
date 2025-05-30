##############################################################
# Null label contexts
##############################################################
module "alb_context" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.this.context
  attributes = ["alb"]
}

##############################################################
# Application load balancer
##############################################################
resource "aws_lb" "alb" {
  name               = module.alb_context.id
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  tags = module.alb_context.tags
}

resource "aws_lb_target_group" "alb" {
  name        = module.alb_context.id
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200-399"
  }

  tags = module.alb_context.tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }

  tags = module.alb_context.tags
}

##############################################################
# Security groups
##############################################################
resource "aws_security_group" "alb" {
  name        = module.alb_context.id
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  tags = module.alb_context.tags
}

resource "aws_vpc_security_group_ingress_rule" "alb" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}