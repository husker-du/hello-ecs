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
  base_source_url = "${get_repo_root()}/infra/modules//ecs"
}

inputs = {
  app_port        = 3000
  image_tag       = "v1.0.0"
  node_env        = "production"

  task_cpu      = 512
  task_memory   = 1024
  desired_count = 2

  logs_retention_days = 7
}
