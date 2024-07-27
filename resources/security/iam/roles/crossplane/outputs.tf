output "role_arn" {
  value = module.ack-role-for-service-accounts-eks.iam_role_arn
}

output "role_name" {
  value = module.ack-role-for-service-accounts-eks.iam_role_name
}