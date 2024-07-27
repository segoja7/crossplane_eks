locals {
  env = {
    default = {
      is_enabled              = false
      deletion_window_in_days = 7
      enable_key_rotation     = true
      enable_default_policy   = false
      key_usage               = "ENCRYPT_DECRYPT"
      name                    = "${var.project}/${terraform.workspace}/resources"
      description             = "Infrastructure key environment ${terraform.workspace} "
      policy                  = data.aws_iam_policy_document.key_policy_infra.json
      tags = {
        Environment = terraform.workspace
        Protected   = "Private"
        layer       = "Security"
      }
    }
    dev = {
      is_enabled = true
    }
    prod = {

    }
  }
  environment_vars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace        = merge(local.env["default"], local.env[local.environment_vars])
}

