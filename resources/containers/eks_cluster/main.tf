
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.11.0"


  cluster_name              = local.workspace["cluster_name"]
  cluster_version           = local.workspace["cluster_version"]
  cluster_enabled_log_types = local.workspace["cluster_enabled_log_types"]

  create_iam_role          = local.workspace["create_iam_role"]
  iam_role_use_name_prefix = local.workspace["iam_role_use_name_prefix"]

  vpc_id     = local.workspace["vpc_id"]
  subnet_ids = local.workspace["subnet_ids"]

  cluster_endpoint_private_access = local.workspace["cluster_endpoint_private_access"]
  cluster_endpoint_public_access  = local.workspace["cluster_endpoint_public_access"]

  create_kms_key                  = local.workspace["create_kms_key"]
  enable_kms_key_rotation         = local.workspace["enable_kms_key_rotation"]
  kms_key_deletion_window_in_days = local.workspace["kms_key_deletion_window_in_days"]
  cluster_encryption_config       = local.workspace["cluster_encryption_config"]

  create_cloudwatch_log_group            = local.workspace["create_cloudwatch_log_group"]
  cloudwatch_log_group_retention_in_days = local.workspace["cloudwatch_log_group_retention_in_days"]
  cloudwatch_log_group_kms_key_id        = local.workspace["cloudwatch_log_group_kms_key_id"]

  cluster_addons                          = local.workspace["cluster_addons"]
  create_cluster_security_group           = local.workspace["create_cluster_security_group"]
  cluster_security_group_use_name_prefix  = local.workspace["cluster_security_group_use_name_prefix"]
  cluster_additional_security_group_ids   = local.workspace["cluster_additional_security_group_ids"]
  cluster_security_group_additional_rules = local.workspace["cluster_security_group_additional_rules"]

  create_node_security_group                   = local.workspace["create_node_security_group"]
  node_security_group_use_name_prefix          = local.workspace["node_security_group_use_name_prefix"]
  node_security_group_additional_rules         = local.workspace["node_security_group_additional_rules"]
  node_security_group_enable_recommended_rules = local.workspace["node_security_group_enable_recommended_rules"]


  eks_managed_node_groups = local.workspace["eks_managed_node_groups"]


  enable_cluster_creator_admin_permissions = local.workspace["enable_cluster_creator_admin_permissions"]
  authentication_mode = local.workspace["authentication_mode"]
  access_entries      = local.workspace["access_entries"]

  tags = merge(
    var.required_tags,
    local.workspace["tags"], {
      "karpenter.sh/discovery" = local.workspace["cluster_name"]
    }
  )
}

