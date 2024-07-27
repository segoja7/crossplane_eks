include "root" {
  path = find_in_parent_folders()
}

dependency "eks" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/containers/eks_cluster"
  mock_outputs = {
    oidc_provider     = "oidc.eks.us-east-1.amazonaws.com/id/BF6121BE00BF7C7AF5B3D5BB9F1CCA71"
    oidc_provider_arn = "arn:aws:iam::804450215614:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/BF6121BE00BF7C7AF5B3D5BB9F1CCA71"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

inputs = {
  oidc_provider     = dependency.eks.outputs.oidc_provider
  oidc_provider_arn = dependency.eks.outputs.oidc_provider_arn
}