data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "key_policy_infra" {
  statement {
    sid    = "Allow access through cloudwatch for all principals in the account that are authorized to use kms"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "logs.${data.aws_region.current.name}.amazonaws.com"
      ]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
      "kms:Get*",
      "kms:CreateGrant*",
      "kms:List*"
    ]
    resources = ["*"]
    condition {
      test = "ArnEquals"
      values = [
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/eks/${var.project}-${terraform.workspace}-eks/cluster",
      ]
      variable = "kms:EncryptionContext:aws:logs:arn"
    }
  }
  statement {
    sid    = "Allow access through for all principals in the account that are authorized to use kms"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
      "kms:Get*",
      "kms:CreateGrant*",
      "kms:List*"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.current.account_id]
      variable = "kms:CallerAccount"
    }
    condition {
      test     = "StringEquals"
      values   = ["secretsmanager.${data.aws_region.current.name}.amazonaws.com"]
      variable = "kms:ViaService"
    }
  }
  statement {
    sid    = "Default"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "kms:*",
    ]
    resources = ["*"]
  }
}