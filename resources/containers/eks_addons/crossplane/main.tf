terraform {
  required_version = ">= 1.3.2"

  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.2"
    }
  }
}

provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", var.cluster_name, "--region", "us-east-1", "--profile", "segoja7"]
  }
}

provider "kubectl" {
  apply_retry_count      = 5
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", var.cluster_name, "--region", "us-east-1", "--profile", "segoja7"]
  }
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", var.cluster_name, "--region", "us-east-1", "--profile", "segoja7"]
    }
  }
}

module "eks-blueprints-addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "1.16.2"

  cluster_name      = local.workspace["cluster_name"]
  cluster_endpoint  = local.workspace["cluster_endpoint"]
  cluster_version   = local.workspace["cluster_version"]
  oidc_provider_arn = local.workspace["oidc_provider_arn"]
  helm_releases     = local.workspace["helm_releases"]
}
