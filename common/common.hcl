# Load variables in locals
locals {
  # Default values for variables
  provider = "aws"
  client   = "cloud"
  project  = "segoja7-cp-iac"

  # Backend Configuration
  backend_profile       = "segoja7"
  backend_region        = "us-east-1"
  backend_bucket_name   = "s3-backend-terraform-cp-iac"
  backend_key           = "terraform.tfstate"
  backend-dynamodb-lock = "dynamodb-backend-terraform-cp-iac"
  backend_encrypt       = true
  # Format cloud provider/client/projectname
  project_folder = "${local.provider}/${local.client}/${local.project}"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
variable "profile" {
  description = "Variable for credentials management."
  type        = map(map(string))
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "required_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

provider "aws" {
  region  = var.profile[terraform.workspace]["region"]
  profile = var.profile[terraform.workspace]["profile"]

  default_tags {
    tags = var.required_tags
  }
}
EOF
}
