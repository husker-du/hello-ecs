# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for vpc. The common variables for each environment to
# deploy vpc are defined here. This configuration will be merged into the environment configuration
# via an include block.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Automatically load environment-level variables
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  env = local.env_vars.locals.stage

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the source URL in the child terragrunt configurations.
  base_source_url = "${get_repo_root()}/infra/modules//ecr"
}

inputs = {
  repository_name            = "demo-project/hello-world"
  image_tag_mutability       = "MUTABLE"
  scan_images_on_push        = false
  keep_last_images           = 15
  untagged_image_expiry_days = 30
  allowed_account_ids = [
    "${get_aws_account_id()}"
  ]

  image_tag           = "v1.0.0"
  docker_context_path = "${get_repo_root()}/infra/hello-world"
  image_source_url    = "https://github.com/irysan/irysan-tech-tests"
  image_vendor        = "ACME"
  image_description   = "Hello world node.js application"
}
