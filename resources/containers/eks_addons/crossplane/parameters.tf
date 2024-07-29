#eks_addons-parameters.tf
locals {
  env = {
    default = {
      create            = false
      cluster_name      = var.cluster_name
      cluster_endpoint  = var.cluster_endpoint
      cluster_version   = var.cluster_platform_version
      oidc_provider_arn = var.oidc_provider_arn

      helm_releases = {
        crossplane = {
          name             = "crossplane-stable"
          description      = "A Helm chart for crossplane"
          namespace        = "crossplane-system"
          chart            = "crossplane"
          create_namespace = true
          repository       = "https://charts.crossplane.io/stable/"
        }
      }
    }
    "dev" = {
      create = true
    }
    "test" = {
      create = true
    }
  }
  environment_vars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace        = merge(local.env["default"], local.env[local.environment_vars])
}
