# Current AWS account id
data "aws_caller_identity" "current" {}

# Authenticate Docker to ECR
data "aws_ecr_authorization_token" "token" {}