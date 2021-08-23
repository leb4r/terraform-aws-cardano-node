module "encryption_key" {
  source  = "cloudposse/kms-key/aws"
  version = "0.10.0"

  enabled = var.create_kms_key

  name                    = "cardano-node"
  description             = "Cardano Node KMS Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}
