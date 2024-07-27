# Default values for deployment credentials
# Access profile in your IDE env or pipeline the IAM user to use for deployment."
profile = {
  default = {
    profile = "segoja7"
    region  = "us-east-1"
  }
  "dev" = {
    profile = "segoja7"
    region  = "us-east-1"
  }
}

# Project Variable
 project  = "segoja7-cp-iac"

# Project default tags
required_tags = {
  Project   = "cp-iac"
  Owner     = "cloud"
  ManagedBy = "Terraform-Terragrunt"
}
