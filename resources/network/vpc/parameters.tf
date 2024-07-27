locals {
  env = {
    default = {
      create                               = false
      name                                 = lower(replace("${var.project}-${terraform.workspace}-vpc", "_", "-"))
      cidr                                 = "10.100.0.0/16"
      enable_dns_hostnames                 = true
      enable_dns_support                   = true
      azs                                  = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
      public_subnets                       = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24", "10.100.7.0/24"]
      private_subnets                      = ["10.100.4.0/24", "10.100.5.0/24", "10.100.6.0/24", "10.100.10.0/24"]
      database_subnets                     = []
      enable_nat_gateway                   = true
      single_nat_gateway                   = true
      one_nat_gateway_per_az               = false
      enable_vpn_gateway                   = false
      enable_flow_log                      = true
      create_flow_log_cloudwatch_iam_role  = true
      create_flow_log_cloudwatch_log_group = true
      flow_log_destination_type            = "cloud-watch-logs"
      public_subnet_tags = {
        lower("kubernetes.io/cluster/${var.project}-${terraform.workspace}-eks") = "owned"
        "kubernetes.io/role/elb"                                                 = 1
      }
      private_subnet_tags = {
        lower("kubernetes.io/cluster/${var.project}-${terraform.workspace}-eks") = "owned"
        "kubernetes.io/role/internal-elb"                                        = 1
        "karpenter.sh/discovery"                                                 = lower(replace("${var.project}-${terraform.workspace}-eks", "_", "-"))
      }
      tags = {
        Environment = terraform.workspace
        Protected   = "Shared"
        layer       = "Network"
      }
    }
    dev = {
      create = true
    }
    prod = {
      create = true
    }
  }
  environment_vars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace        = merge(local.env["default"], local.env[local.environment_vars])
}