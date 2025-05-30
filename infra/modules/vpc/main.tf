##############################################################
# Null label contexts
##############################################################
module "vpc_context" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.this.context
  attributes = ["vpc"]
}

module "public_context" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.this.context
  attributes = ["public"]

  tags = merge(
    module.this.tags,
    {
      # Tag subnets to be used for external ELBs created by LoadBalancer services
      "kubernetes.io/role/elb" = 1
    }
  )
}

module "private_context" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.this.context
  attributes = ["private"]

  tags = merge(
    module.this.tags,
    {
      # Tag subnets to be used for internal ELBs created by LoadBalancer services
      "kubernetes.io/role/internal-elb" = 1
      # Tags subnets for Karpenter auto-discovery
      "karpenter.sh/discovery" = var.cluster_name
    }
  )
}

module "intra_context" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.this.context
  attributes = ["intra"]
}

##############################################################
# VPC
##############################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = module.vpc_context.id
  cidr = var.vpc_cidr

  azs             = local.azs
  public_subnets  = local.public_cidrs
  private_subnets = local.private_cidrs
  intra_subnets   = local.intra_cidrs

  public_subnet_tags  = module.public_context.tags
  private_subnet_tags = module.private_context.tags
  intra_subnet_tags   = module.intra_context.tags

  public_subnet_tags_per_az  = { for az in local.azs : "${az}" => { Name = "${module.public_context.id}-${az}" } }
  private_subnet_tags_per_az = { for az in local.azs : "${az}" => { Name = "${module.private_context.id}-${az}" } }

  public_route_table_tags  = { Name = "${module.public_context.id}-rtb" }
  private_route_table_tags = { Name = "${module.private_context.id}-rtb" }
  intra_route_table_tags   = { Name = "${module.intra_context.id}-rtb" }

  enable_nat_gateway   = true
  single_nat_gateway   = true
  create_igw           = true
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = module.vpc_context.tags
}
