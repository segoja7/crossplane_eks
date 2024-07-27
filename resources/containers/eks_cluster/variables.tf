variable "vpc_id" {
  description = "VPC Id"
  type        = string
  default     = ""
}

variable "private_subnets" {
  description = "A list of VPC private subnet IDs"
  type        = list(string)
  default     = []
}

variable "kms_arn" {
  description = "ARN of the KMS key to encrypt elements of the cluster"
  type        = string
  default     = ""
}

# variable "role_arn" {
#   description = "The ARN of the instance"
#   type        = string
# }


