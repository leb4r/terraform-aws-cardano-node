locals {
  kms_key_arn = var.create_kms_key ? module.kms.key_arn : var.kms_key_arn
}

module "kms" {
  source         = "./modules/kms"
  create_kms_key = var.create_kms_key
  name           = var.name
  tags           = var.tags
}

module "logs" {
  source            = "./modules/logs"
  kms_key_arn       = local.kms_key_arn
  retention_in_days = var.log_retention_in_days
  name              = var.name
  tags              = var.tags
}

module "config" {
  source      = "./modules/config"
  kms_key_arn = local.kms_key_arn

  cardano_node_network       = var.cardano_node_network
  cardano_node_port          = var.cardano_node_port
  cardano_node_image         = var.cardano_node_image
  cardano_node_version       = var.cardano_node_version
  cardano_node_topology_json = var.cardano_node_topology_json
  log_group_name             = module.logs.log_group_name

  name = var.name
  tags = var.tags
}

module "automation" {
  source             = "./modules/automation"
  config_bucket_name = module.config.bucket_name
}

module "iam" {
  source            = "./modules/iam"
  ssm_managed       = true
  config_bucket_arn = module.config.bucket_arn
  kms_key_arn       = local.kms_key_arn
  name              = var.name
  tags              = var.tags
}

module "node" {
  source                      = "./modules/node"
  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  kms_key_arn                 = local.kms_key_arn
  iam_instance_profile_name   = module.iam.instance_profile_name
  associate_public_ip_address = var.associate_public_ip_address
  enable_monitoring           = var.enable_monitoring
  ebs_optimized               = var.ebs_optimized
  data_volume_size            = var.data_volume_size
  instance_type               = var.instance_type
  config_bucket_name          = module.config.bucket_name
  prometheus_ingress_cidrs    = var.prometheus_ingress_cidrs
  root_volume_size            = var.root_volume_size
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

module "backups" {
  source                    = "./modules/backup"
  kms_key_arn               = local.kms_key_arn
  backup_schedule           = var.backup_schedule
  backup_cold_storage_after = var.backup_cold_storage_after
  backup_delete_after       = var.backup_delete_after

  backup_resources = [
    module.node.arn
  ]
}
