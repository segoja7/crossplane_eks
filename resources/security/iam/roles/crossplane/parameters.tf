locals {
  env = {
    default = {
      create    = false
      role_name = lower("${var.project}-${terraform.workspace}-crossplane-controller")
      role_policy_arns = {
        AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
      }
      assume_role_condition_test = "StringLike"
      oidc_providers = {
        ex = {
          provider_arn               = var.oidc_provider_arn
          namespace_service_accounts = ["crossplane-system:provider-aws-*"]
        }
      }

      tags = {
        Environment = terraform.workspace
        Protected   = "Private"
        Layer       = "Security"
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