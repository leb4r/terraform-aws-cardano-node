locals {
  kms_key_arn = var.create_kms_key ? module.kms.key_arn : var.kms_key_arn
}

module "kms" {
  source         = "./modules/kms"
  create_kms_key = var.create_kms_key
  name           = var.name
  tags           = var.tags
}

module "storage" {
  source            = "./modules/storage"
  availability_zone = data.aws_subnet.this.availability_zone
  volume_size       = var.data_volume_size
  kms_key_arn       = local.kms_key_arn
}

module "logs" {
  source            = "./modules/logs"
  kms_key_arn       = local.kms_key_arn
  retention_in_days = var.log_retention_in_days
  name              = var.name
  tags              = var.tags
}

module "config" {
  source            = "./modules/config"
  kms_key_arn       = local.kms_key_arn
  storage_volume_id = module.storage.id

  cardano_node_network = var.cardano_node_network
  cardano_node_port    = var.cardano_node_port
  cardano_node_image   = var.cardano_node_image
  cardano_node_version = var.cardano_node_version
  log_group_name       = module.logs.log_group_name

  name = var.name
  tags = var.tags
}

data "aws_subnet" "this" {
  id = var.subnet_id
}

module "iam" {
  source            = "./modules/iam"
  ssm_managed       = true
  config_bucket_arn = module.config.bucket_arn
  kms_key_arn       = local.kms_key_arn
  log_group_arn     = module.logs.log_group_arn
  name              = var.name
  tags              = var.tags
}

module "node" {
  source                      = "./modules/node"
  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  kms_key_arn                 = local.kms_key_arn
  iam_role_name               = module.iam.role_name
  associate_public_ip_address = var.associate_public_ip_address
  storage_volume_id           = module.storage.id
  config_bucket_name          = module.config.bucket_name
  name                        = var.name
  tags                        = var.tags
}

module "dns" {
  source                = "./modules/dns"
  create_route53_record = var.create_route53_record
  route53_zone_id       = var.route53_zone_id
  route53_record_name   = var.route53_record_name
  ip_address            = module.node.private_ip_address
}
