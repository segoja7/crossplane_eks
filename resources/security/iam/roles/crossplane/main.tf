module "ack-role-for-service-accounts-eks" {

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.39.1"

  role_name        = local.workspace["role_name"]
  role_policy_arns = local.workspace["role_policy_arns"]
  assume_role_condition_test = local.workspace["assume_role_condition_test"]
  oidc_providers = local.workspace["oidc_providers"]

  tags = merge(
    var.required_tags,
    local.workspace["tags"]
  )
}