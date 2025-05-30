output "vpc_id" {
  description = "The id of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "intra_subnet_ids" {
  description = "Intra subnet CIDR blocks"
  value       = module.vpc.intra_subnets
}

output "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "intra_subnet_cidrs" {
  description = "Intra subnet CIDR blocks"
  value       = module.vpc.intra_subnets_cidr_blocks
}

output "private_route_table_ids" {
  description = "The IDs of the route table associated to private subnets"
  value       = module.vpc.private_route_table_ids
}
