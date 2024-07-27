#eks_addons-terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

dependency "eks_cluster" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/containers/eks_cluster"
  mock_outputs = {
    cluster_name                       = "tesoreriavita-dev-eks"
    cluster_endpoint                   = "https://079D14396FF80B834323D6B86117CDA8.gr7.us-east-1.eks.amazonaws.com"
    cluster_platform_version           = "eks.7"
    oidc_provider_arn                  = "arn:aws:iam::157039837889:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/079D14396FF80B834323D6B86117CDA8"
    cluster_certificate_authority_data = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJQk1DWkJmRTRiZkl3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TkRBMU1qSXdNREEwTXpOYUZ3MHpOREExTWpBd01EQTVNek5hTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUUM3R1M2YUlTTFJFSFE0MHl2OVhqMVNObUNtM0hOcFRyVFloSDN5akFuSzRTazRQZWRSRDUxb2pZeVYKY1hlb2F1K3kwYmkwenZvM0wxRVlrUGttM0I5NEFvbWlFdnZ3ejNhZjNHVldTcjFDSi80cVc3Q0NiaERLS0V5bApQKzhRYnRwSmQvVTRIWE96UHZNMzRsZmJrSVJKTkJNQnJCVmdnenl6b1dRZ3NDRFBxT1RieTRTSzNCVlE0VmVPCktRTHhncEZjK3BmbG1JT3NOdGxjd0xiS3dnaWpkRGdxcGREOTBRMFF1dnAwWkdSbUlVQ1pNcTdRbEx2RGV0bi8KWUptWlF4cFl1L0IrOTFaRjRDbDRoMW9UdUQrNWFUcVJoVE5ZWW9pSVdNM1dlbjArdU1kL3FqUUNJZ2VpQm9kNQpGV2x5QllFQXI2dGJTWDJwZ1VqRE5Zc2grTzhGQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJTTmRBNjZ1N1dYbDZMZkJIU0RTSzVHQlJleXpUQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQVlLTlJRRnNOUApyT25zc3ZqVFRwem41STRFZytMUFpLUjg1VnJZV0YrTjFwREZialpXQ1IyMnZDbFlNZzBhenllWEhsOXo5OXU2CjVLREpZMTNZbmlFb1YrcEtRRmk5cjVZQ2FRdzRXcXZnZ0hLak8xb3ZEckV5UDBaRmZ1djY1dHVhc1Z0N0p5Y3cKMXBLREJIZjVTVjAxczQ3T0JGaDlmTUlLL0N2bnlJMjVJRk1ua3FDdkk5cVhEVG83U1Q0RkFZbllmL2UrakRqKwpLRnFpSGUvVnNOSUJuYjRaNzkwR1RVRTlvbjhjUXVWNGo5anZSVWxzbnlHT1BiRkI5a2dvQ1NCRFNDUHBqdTlQCitOVzgyM0hQcjdRQmlaU1JBalNiemYrbXcwUEk0SHNMSFJPcmlhc2pKVEtZc0FSc0dIcVdURFcyN3JzZmt4VlMKUDFpK0R0b1l3YzdDCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"
    eks_managed_node_groups_role       = "arn:aws:iam::157039837889:role/managed-ondemand-eks-node-group-20240521134521869400000002"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

# dependency "role_ack_controller" {
#   config_path = "${get_parent_terragrunt_dir("root")}/resources/security/iam/roles/crossplane"
#   mock_outputs = {
#     role_arn = "arn:aws:iam::157039837889:role/tesoreriavita-dev-ack-controller"
#   }
#   mock_outputs_merge_strategy_with_state = "shallow"
# }


inputs = {
  cluster_name                              = dependency.eks_cluster.outputs.cluster_name
  cluster_endpoint                          = dependency.eks_cluster.outputs.cluster_endpoint
  cluster_platform_version                  = dependency.eks_cluster.outputs.cluster_platform_version
  oidc_provider_arn                         = dependency.eks_cluster.outputs.oidc_provider_arn
  cluster_certificate_authority_data        = dependency.eks_cluster.outputs.cluster_certificate_authority_data
#   eks_managed_node_groups_role_iam_role_arn = dependency.eks_cluster.outputs.eks_managed_node_groups_role
#   role_arn_controller                = dependency.role_ack_controller.outputs.role_arn

}