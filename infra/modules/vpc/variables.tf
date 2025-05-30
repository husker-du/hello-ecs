variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = ""
  type        = string
  default     = "10.0.0.0/16"
}

variable "num_azs" {
  description = "Number of availability zones for the subnets"
  type        = number
  default     = 3
}

variable "enable_dns_hostnames" {
  description = "Whether to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Whether to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "public_prefix" {
  description = "Prefix of the public subnets CIDR blocks"
  type        = number
  default     = 20
}

variable "private_prefix" {
  description = "Prefix of the private subnets CIDR blocks"
  type        = number
  default     = 20
}

variable "intra_prefix" {
  description = "Prefix of the intra subnets CIDR blocks"
  type        = number
  default     = 20
}

variable "cluster_name" {
  description = "The EKS cluster name (for discoverability by the karpenter controller)"
  type        = string
  default     = "demo"
}

##################################################
# Interface vpc endpoints submodule
##################################################
variable "enable_vpc_endpoints" {
  description = "Enable the creation of interface vpc endpoints"
  type        = bool
  default     = false
}

variable "vpc_endpoints" {
  description = "Map of interface and gateway vpc endpoints to create"
  type = object({
    Gateway   = optional(list(string))
    Interface = optional(list(string))
  })
  default = {
    Gateway   = []
    Interface = []
  }
}
