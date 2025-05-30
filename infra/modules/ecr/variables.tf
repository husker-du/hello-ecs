variable "region" {
  description = "AWS region where the ECR repository will be created"
  type        = string
  default     = "us-east-1"
}

#####################################################
# ECR repository
#####################################################
variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "hello-world"
}

variable "image_tag_mutability" {
  description = "Whether image tags are mutable (MUTABLE) or immutable (IMMUTABLE)"
  type        = string
  default     = "MUTABLE"
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "Must be either MUTABLE or IMMUTABLE"
  }
}

variable "scan_images_on_push" {
  description = "Whether to scan images on push"
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "Encryption type for the repository (AES256 or KMS)"
  type        = string
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "Must be either AES256 or KMS"
  }
}

variable "kms_key_arn" {
  description = "ARN of the KMS key to use for encryption (required if encryption_type is KMS)"
  type        = string
  default     = ""
}

variable "keep_last_images" {
  description = "Number of images to keep in the repository"
  type        = number
  default     = 30
}

variable "untagged_image_expiry_days" {
  description = "Number of days to keep untagged images"
  type        = number
  default     = 7
}

variable "allowed_account_ids" {
  description = "List of AWS account IDs allowed to push/pull images"
  type        = list(string)
  default     = []
}

#####################################################
# Docker image
#####################################################
variable "image_tag" {
  description = "Tag to apply to the Docker image"
  type        = string
  default     = "latest"
  validation {
    condition     = can(regex("^v[0-9]", var.image_tag)) || var.image_tag == "latest"
    error_message = "Image tag must start with 'v' followed by a number (e.g., v1.0.0) or be 'latest'."
  }
}

variable "docker_context_path" {
  description = "Path to the directory containing your Dockerfile and application code"
  type        = string
  default     = "../" # Points to parent directory by default
}

variable "dockerfile_path" {
  description = "Path to Dockerfile relative to context path"
  type        = string
  default     = "Dockerfile"
}

variable "app_port" {
  description = "Port your application listens on"
  type        = number
  default     = 3000
}

variable "image_source_url" {
  description = "URL to the source code repository"
  type        = string
  default     = ""
}

variable "image_vendor" {
  description = "Organization/entity that created the image"
  type        = string
  default     = ""
}

variable "image_description" {
  description = "Description of the Docker image"
  type        = string
  default     = "Application container image"
}
