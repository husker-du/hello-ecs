#####################################################
# ECR
#####################################################
output "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.hello_world.arn
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.hello_world.repository_url
}

output "ecr_repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.hello_world.name
}

output "registry_id" {
  description = "Registry ID where the repository was created"
  value       = aws_ecr_repository.hello_world.registry_id
}


#####################################################
# Docker
#####################################################
output "image_uri" {
  description = "Full URI of the pushed Docker image"
  value       = docker_image.hello_world.name
}

output "image_digest" {
  description = "Content digest of the pushed image"
  value       = docker_registry_image.hello_world.sha256_digest
}

output "pull_command" {
  description = "Command to pull the image"
  value       = "docker pull ${docker_image.hello_world.name}"
}

output "run_command" {
  description = "Command to run the container"
  value       = "docker run -p ${var.app_port}:${var.app_port} -d ${docker_image.hello_world.name}"
}