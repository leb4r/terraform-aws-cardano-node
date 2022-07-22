module "relay_config" {
  source      = "../../modules/config"
  name        = local.name
  kms_key_arn = module.encryption_key.key_arn
}

module "relay_automation" {
  source             = "../../modules/automation"
  config_bucket_name = module.relay_config.bucket_name
}

module "relay_iam" {
  source            = "../../modules/iam"
  name              = local.name
  kms_key_arn       = module.encryption_key.key_arn
  config_bucket_arn = module.relay_config.bucket_arn
}

module "relay_node" {
  source = "../../modules/node"
  count  = local.num_of_relays

  vpc_id                      = module.vpc.vpc_id
  subnet_id                   = module.vpc.public_subnets[count.index]
  associate_public_ip_address = true
  config_bucket_name          = module.relay_config.bucket_name
  kms_key_arn                 = module.encryption_key.key_arn
  iam_instance_profile_name   = module.relay_iam.instance_profile_name

  # create_route53_record = true
  # route53_zone_id       = module.dns.route53_zone_zone_id[local.public_zone_name]
  # route53_record_name   = "relay-${count.index}"
}
