terraform {
  required_version = ">= 1.12.0" # Ensure Terraform is at least v1.12.0

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.98" # Allows any 5.x version but prevents 6.0+
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.0"
    }
  }
}
