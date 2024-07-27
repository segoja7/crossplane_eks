output "key_aliases" {
  value       = module.kms.aliases
  description = "A map of aliases created and their attributes"
}

output "key_id" {
  value       = module.kms.key_id
  description = "The globally unique identifier for the key"
}

output "key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = module.kms.key_arn
}
