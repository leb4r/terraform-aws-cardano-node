module "encryption_key" {
  source  = "cloudposse/kms-key/aws"
  version = "0.10.0"

  enabled = var.create_kms_key

  name                    = "cardano-node"
  description             = "Cardano Node KMS Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

data "aws_iam_policy_document" "encryption_key_access" {
  statement {
    sid    = "AllowUseOfEncryptionKey"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:ReEncrypt",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = [var.create_kms_key ? module.encryption_key.key_arn : var.kms_key_arn]
  }
}

resource "aws_iam_policy" "encryption_key_access" {
  name_prefix = "cardano-node-encryption-key-access-policy"
  policy      = data.aws_iam_policy_document.encryption_key_access.json
  tags        = var.tags
}
