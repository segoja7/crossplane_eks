variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  type        = string
}

variable "cluster_platform_version" {
  description = "Platform version for the cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  type        = string
}

variable "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  type        = string
}


# variable "eks_managed_node_groups_role_iam_role_arn" {
#   description = "The Amazon Resource Name (ARN) specifying the IAM role"
#   type        = string
# }
#
# variable "role_arn_controller" {
#   description = "Arn AWS Load Balancer Controller"
#   type        = string
# }