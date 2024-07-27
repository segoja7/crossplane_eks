variable "policies_arns" {
  description = "List of policies that you want to add to the instance profile"
  type        = list(string)
  default     = []
}

variable "oidc_provider" {
  description = "The OIDC Provider"
  type        = string
  default     = ""
}

variable "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  type        = string
  default     = ""
}