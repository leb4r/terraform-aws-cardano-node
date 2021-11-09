module "block_producer_config" {
  source      = "../../modules/config"
  name        = local.name
  kms_key_arn = module.encryption_key.key_arn

  cardano_node_topology_json = <<-EOF
  {
    "Producers": [
      {for ip in module.relay_node}
      {
        "addr": "${module.relay_node[0].private_ip_address}",
        "port": 3001,
        "valency": 1
      }
    ]
  }
  EOF
}

module "block_producer_iam" {
  source            = "../../modules/iam"
  name              = local.name
  kms_key_arn       = module.encryption_key.key_arn
  log_group_arn     = module.logs.log_group_arn
  config_bucket_arn = module.block_producer_config.bucket_arn
}

module "block_producer" {
  source = "../../modules/node"
  count  = local.num_of_producers

  vpc_id                      = module.vpc.vpc_id
  subnet_id                   = module.vpc.private_subnets[count.index]
  associate_public_ip_address = false
  config_bucket_name          = module.block_producer_config.bucket_name
  kms_key_arn                 = module.encryption_key.key_arn
  iam_instance_profile_name   = module.block_producer_iam.instance_profile_name

  # create_route53_record = true
  # route53_zone_id       = module.dns.route53_zone_zone_id[local.private_zone_name]
  # route53_record_name   = "block-producer-${count.index}"
}
