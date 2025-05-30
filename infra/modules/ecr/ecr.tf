##############################################################
# Null label contexts
##############################################################
module "ecr_context" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.this.context
  attributes = ["ecr", "hello-world"]
}

##############################################################
# ECR repository
##############################################################
resource "aws_ecr_repository" "hello_world" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_images_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.kms_key_arn != "" ? var.kms_key_arn : null
  }

  tags = module.ecr_context.tags
}

resource "aws_ecr_lifecycle_policy" "hello_world" {
  repository = aws_ecr_repository.hello_world.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.keep_last_images} images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = var.keep_last_images
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Remove untagged images older than ${var.untagged_image_expiry_days} days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countNumber = var.untagged_image_expiry_days
          countUnit   = "days"
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# resource "aws_ecr_repository_policy" "hello_world" {
#   repository = aws_ecr_repository.hello_world.name
#   policy     = data.aws_iam_policy_document.ecr_default_policy.json
# }

# data "aws_iam_policy_document" "ecr_default_policy" {
#   statement {
#     sid    = "AllowPushPull"
#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = var.allowed_account_ids
#     }

#     actions = [
#       "ecr:GetDownloadUrlForLayer",
#       "ecr:BatchGetImage",
#       "ecr:BatchCheckLayerAvailability",
#       "ecr:PutImage",
#       "ecr:InitiateLayerUpload",
#       "ecr:UploadLayerPart",
#       "ecr:CompleteLayerUpload"
#     ]
#   }
# }
