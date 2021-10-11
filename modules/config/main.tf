locals {
  cardano_node_topology_json = var.cardano_node_topology_json != "" ? var.cardano_node_topology_json : <<-EOF
  {
    "Producers": [
      {
        "addr": "relays-new.cardano-${var.cardano_node_network}.iohk.io",
        "port": 3001,
        "valency": 1
      }
    ]
  }
  EOF
}

module "config_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.5.0"

  bucket_prefix = "${var.name}-config-"
  acl           = "private"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  tags = var.tags
}

resource "aws_s3_bucket_object" "topology" {
  bucket     = module.config_bucket.s3_bucket_id
  key        = "${var.cardano_node_network}-topology.json"
  content    = local.cardano_node_topology_json
  kms_key_id = var.kms_key_arn
  tags       = var.tags
}

data "aws_region" "current" {}

resource "aws_s3_bucket_object" "compose" {
  bucket     = module.config_bucket.s3_bucket_id
  key        = "docker-compose.yml"
  kms_key_id = var.kms_key_arn
  tags       = var.tags

  content = templatefile("${path.module}/templates/docker-compose.yml.tpl", {
    cardano_network      = var.cardano_node_network,
    cardano_node_image   = var.cardano_node_image,
    cardano_node_port    = var.cardano_node_port,
    cardano_node_version = var.cardano_node_version
    log_group_name       = var.log_group_name
    region               = data.aws_region.current.name
  })
}

## usedata

locals {
  data_volume_device_name = "/dev/sdh"
}

data "cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    filename     = "user-data.sh"

    content = templatefile("${path.module}/templates/user-data.sh.tpl", {
      cardano_network      = var.cardano_node_network,
      cardano_node_image   = var.cardano_node_image,
      cardano_node_version = var.cardano_node_version,
      config_bucket_name   = module.config_bucket.s3_bucket_id,
      ebs_volume_id        = var.storage_volume_id
      log_group_name       = var.log_group_name
    })
  }
}
