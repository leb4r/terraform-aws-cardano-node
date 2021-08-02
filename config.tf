locals {
  cardano_topology_json = var.cardano_topology_json != "" ? var.cardano_topology_json : <<-EOF
  {
    "Producers": [
      {
        "addr": "relays-new.cardano-${var.cardano_network}.iohk.io",
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

  bucket_prefix = "cardano-node-config-"
  acl           = "private"

  versioning = {
    enabled = true
  }

  tags = var.tags
}

resource "aws_s3_bucket_object" "topology" {
  bucket  = module.config_bucket.s3_bucket_id
  key     = "${var.cardano_network}-topology.json"
  content = local.cardano_topology_json
  tags    = var.tags
}

resource "aws_s3_bucket_object" "compose" {
  bucket = module.config_bucket.s3_bucket_id
  key    = "docker-compose.yml"
  tags   = var.tags

  content = templatefile("${path.module}/templates/docker-compose.yml.tpl", {
    cardano_network      = var.cardano_network,
    cardano_node_image   = var.cardano_node_image,
    cardano_node_port    = var.cardano_node_port,
    cardano_node_version = var.cardano_node_version
  })
}

data "aws_iam_policy_document" "config_access_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      module.config_bucket.s3_bucket_arn
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${module.config_bucket.s3_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "config_access_policy" {
  name_prefix = "cardano-node-config-access-policy-"
  policy      = data.aws_iam_policy_document.config_access_policy.json
  tags        = var.tags
}
