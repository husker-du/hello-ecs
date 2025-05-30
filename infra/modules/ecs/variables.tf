variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "app_port" {
  description = "Port exposed by the Docker image"
  type        = number
  default     = 3000
}

variable "node_env" {
  description = "Node environment"
  type        = string
  default     = "production"
}

variable "docker_image" {
  description = "The image used to start a service in a container"
  type        = string
  default     = "hello-world:latest"
}

variable "repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "nodejs-express-app"
}

variable "task_cpu" {
  description = "Fargate task CPU units"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Fargate task memory (MB)"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 1
}

variable "logs_retention_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  type        = number
  default     = 7
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ECS"
  type        = list(string)
}
