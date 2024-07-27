include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/network/vpc"
  mock_outputs = {
    vpc_id = "vpc-02a7010855b70aed8"
    public_subnets = [
      "subnet-07d15145e8fc861d4",
      "subnet-0841f82f96ec746ff",
    ]
    private_subnets = [
      "subnet-06ee8b2d8f4f6fab4",
      "subnet-0960dabd84080dc76",
    ]
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "kms" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/security/kms/infrastructure"
  mock_outputs = {
    key_arn = "arn:aws:kms:us-east-1:804450215614:alias/eks-pattern/dev/key-eks"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

# dependency "instance_profile" {
#   config_path = "${get_parent_terragrunt_dir("root")}/resources/security/iam/roles/instance_profile/ec2_bastion"
#   mock_outputs = {
#     role_arn = "arn:aws:iam::157039837889:role/segoja7-crossplane-dev-bastion-role"
#   }
#   mock_outputs_merge_strategy_with_state = "shallow"
# }


inputs = {
  vpc_id                               = dependency.vpc.outputs.vpc_id
  private_subnets                      = dependency.vpc.outputs.private_subnets
  kms_arn                              = dependency.kms.outputs.key_arn
#  role_arn                             = dependency.instance_profile.outputs.role_arn
}