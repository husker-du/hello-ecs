# Build docker image
resource "docker_image" "hello_world" {
  name = "${aws_ecr_repository.hello_world.repository_url}:${var.image_tag}"
  build {
    context    = var.docker_context_path
    dockerfile = var.dockerfile_path
    build_args = {
      NODE_ENV = "production"
      PORT     = var.app_port
    }
    labels = {
      "org.opencontainers.image.created"       = timestamp()
      "org.opencontainers.image.source"        = var.image_source_url
      "org.opencontainers.image.vendor"        = var.image_vendor
      "org.opencontainers.image.version"       = var.image_tag
      "org.opencontainers.image.description"   = var.image_description
    }
  }

  triggers = {
    dir_sha1 = sha1(join("", [
      for f in fileset(var.docker_context_path, "**") : filesha1("${var.docker_context_path}/${f}")
    ]))
  }
}

# Push docker image to ECR
resource "docker_registry_image" "hello_world" {
  name          = docker_image.hello_world.name
  keep_remotely = true # Keep image in registry even if the resource is destroyed
}
