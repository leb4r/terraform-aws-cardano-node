provider "aws" {
  region = local.region
}

locals {
  region = "us-east-1"

  public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

  private_zone_name = "private-cardano-staking-pool-example.com"
  public_zone_name  = "cardano-staking-pool-example.com"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name = "cardano-staking-pool-example"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b"]
  private_subnets = local.private_subnet_cidrs
  public_subnets  = local.public_subnet_cidrs

  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_dhcp_options      = true
  dhcp_options_domain_name = local.private_zone_name

  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []

  vpc_tags = {
    Name = "cardano-staking-pool"
  }
}

module "dns" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "2.1.0"

  zones = {
    "private-cardano-staking-pool-example.com" = {
      comment = "private-cardano-staking-pool-example.com (private)"
      vpc = [
        {
          vpc_id = module.vpc.vpc_id
        }
      ]
    },
    "cardano-staking-pool-example.com" = {
      comment = "cardano-staking-pool-example.com (public)"
    }
  }
}

module "encryption_key" {
  source  = "cloudposse/kms-key/aws"
  version = "0.10.0"

  name                    = "cardano-staking-pool"
  description             = "Cardano Staking Pool KMS key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

module "relay_node" {
  source = "../../"
  count  = length(local.public_subnet_cidrs)

  vpc_id                      = module.vpc.vpc_id
  subnet_id                   = module.vpc.public_subnets[count.index]
  associate_public_ip_address = true

  ebs_encrypted  = true
  ebs_kms_key_id = module.encryption_key.key_arn

  create_route53_record = true
  route53_zone_id       = module.dns.route53_zone_zone_id[local.public_zone_name]
  route53_record_name   = "relay-${count.index}"
}

module "block_producer" {
  source = "../../"
  count  = length(local.private_subnet_cidrs)

  vpc_id                      = module.vpc.vpc_id
  subnet_id                   = module.vpc.private_subnets[count.index]
  associate_public_ip_address = false

  ebs_encrypted  = true
  ebs_kms_key_id = module.encryption_key.key_arn

  create_route53_record = true
  route53_zone_id       = module.dns.route53_zone_zone_id[local.private_zone_name]
  route53_record_name   = "block-producer-${count.index}"
}
