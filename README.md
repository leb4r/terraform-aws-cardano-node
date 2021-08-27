# terraform-aws-ec2-cardano-node

Terraform module that provisions a Cardano node on an EC2 instance.

## Security

This project has not be audited for security by a third-party. Use at your own discretion.

| Benchmark                                                                                                                                                                                                                                                | Description                                                      |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| [![Infrastructure Security](https://www.bridgecrew.cloud/badges/github/leb4r/terraform-aws-ec2-cardano-node/general)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=leb4r%2Fterraform-aws-ec2-cardano-node&benchmark=INFRASTRUCTURE+SECURITY) | Infrastructure Security Compliance                               |
| [![CIS KUBERNETES](https://www.bridgecrew.cloud/badges/github/leb4r/terraform-aws-ec2-cardano-node/cis_kubernetes)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=leb4r%2Fterraform-aws-ec2-cardano-node&benchmark=CIS+KUBERNETES+V1.5)       | Center for Internet Security, KUBERNETES Compliance              |
| [![CIS AWS](https://www.bridgecrew.cloud/badges/github/leb4r/terraform-aws-ec2-cardano-node/cis_aws)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=leb4r%2Fterraform-aws-ec2-cardano-node&benchmark=CIS+AWS+V1.2)                            | Center for Internet Security, AWS Compliance                     |
| [![CIS AZURE](https://www.bridgecrew.cloud/badges/github/leb4r/terraform-aws-ec2-cardano-node/cis_azure)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=leb4r%2Fterraform-aws-ec2-cardano-node&benchmark=CIS+AZURE+V1.1)                      | Center for Internet Security, AZURE Compliance                   |
| [![PCI-DSS](https://www.bridgecrew.cloud/badges/github/leb4r/terraform-aws-ec2-cardano-node/pci)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=leb4r%2Fterraform-aws-ec2-cardano-node&benchmark=PCI-DSS+V3.2)                                | Payment Card Industry Data Security Standards Compliance         |
| [![NIST-800-53](https://www.bridgecrew.cloud/badges/github/leb4r/terraform-aws-ec2-cardano-node/nist)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=leb4r%2Fterraform-aws-ec2-cardano-node&benchmark=NIST-800-53)                            | National Institute of Standards and Technology Compliance        |
| [![ISO27001](https://www.bridgecrew.cloud/badges/github/leb4r/terraform-aws-ec2-cardano-node/iso)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=leb4r%2Fterraform-aws-ec2-cardano-node&benchmark=ISO27001)                                   | Information Security Management System, ISO/IEC 27001 Compliance |
| [![SOC2](https://www.bridgecrew.cloud/badges/github/leb4r/terraform-aws-ec2-cardano-node/soc2)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=leb4r%2Fterraform-aws-ec2-cardano-node&benchmark=SOC2)                                          | Service Organization Control 2 Compliance                        |
| [![CIS GCP](https://www.bridgecrew.cloud/badges/github/leb4r/terraform-aws-ec2-cardano-node/cis_gcp)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=leb4r%2Fterraform-aws-ec2-cardano-node&benchmark=CIS+GCP+V1.1)                            | Center for Internet Security, GCP Compliance                     |
| [![HIPAA](https://www.bridgecrew.cloud/badges/github/leb4r/terraform-aws-ec2-cardano-node/hipaa)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=leb4r%2Fterraform-aws-ec2-cardano-node&benchmark=HIPAA)                                       | Health Insurance Portability and Accountability Compliance       |

## Usage

This example my be using a `version` that is out-of-date, check [the registry page](https://registry.terraform.io/modules/leb4r/ec2-cardano-node/aws/latest) for the most recent usage.

```hcl
module "ec2-cardano-node" {
  source  = "leb4r/ec2-cardano-node/aws"
  version = "0.0.2"
  # insert the 4 required variables here
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.24 |
| <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) | >= 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.51.0 |
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backup"></a> [backup](#module\_backup) | cloudposse/backup/aws | 0.9.0 |
| <a name="module_config_bucket"></a> [config\_bucket](#module\_config\_bucket) | terraform-aws-modules/s3-bucket/aws | 2.5.0 |
| <a name="module_ec2_instance"></a> [ec2\_instance](#module\_ec2\_instance) | terraform-aws-modules/ec2-instance/aws | 2.19.0 |
| <a name="module_encryption_key"></a> [encryption\_key](#module\_encryption\_key) | cloudposse/kms-key/aws | 0.10.0 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | terraform-aws-modules/security-group/aws | 4.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ebs_volume.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_iam_instance_profile.cardano_node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.attach_data_volume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.config_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.encryption_key_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cardano_node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.access_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.access_encryption_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.attach_data_volume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket_object.compose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_object.topology](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_ami.amazon_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy_document.attach_data_volume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cardano_node_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.config_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.encryption_key_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [cloudinit_config.user_data](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Whether to associate a public IPv4 address for the node | `bool` | `false` | no |
| <a name="input_backup_cold_storage_after"></a> [backup\_cold\_storage\_after](#input\_backup\_cold\_storage\_after) | Specifies the number of days after creation that a recovery point is moved to cold storage | `number` | `30` | no |
| <a name="input_backup_delete_after"></a> [backup\_delete\_after](#input\_backup\_delete\_after) | Specifies the number of days after creation that a recovery point is deleted. Must be 90 days greater than `cold_storage_after` | `number` | `180` | no |
| <a name="input_backup_schedule"></a> [backup\_schedule](#input\_backup\_schedule) | A CRON expression specifying when AWS Backup initiates a backup job | `string` | `"cron(0 12 * * ? *)"` | no |
| <a name="input_cardano_network"></a> [cardano\_network](#input\_cardano\_network) | The cardano network to connect to, (e.g. `mainnet` or `testnet`) | `string` | `"mainnet"` | no |
| <a name="input_cardano_node_image"></a> [cardano\_node\_image](#input\_cardano\_node\_image) | Container image to use for the node | `string` | `"docker.io/inputoutput/cardano-node"` | no |
| <a name="input_cardano_node_port"></a> [cardano\_node\_port](#input\_cardano\_node\_port) | The port to listen for communication on | `number` | `3001` | no |
| <a name="input_cardano_node_version"></a> [cardano\_node\_version](#input\_cardano\_node\_version) | Version of cardano-node to run | `string` | `"1.29.0"` | no |
| <a name="input_cardano_topology_json"></a> [cardano\_topology\_json](#input\_cardano\_topology\_json) | JSON string to be used as topology config | `string` | `""` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Set to `false` to use separate KMS key | `bool` | `true` | no |
| <a name="input_create_route53_record"></a> [create\_route53\_record](#input\_create\_route53\_record) | Set to `true` to create an A record in Route 53 for the EC2 instance | `bool` | `false` | no |
| <a name="input_data_volume_size"></a> [data\_volume\_size](#input\_data\_volume\_size) | Size of data volume of the node | `number` | `30` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | Whether the EC2 instance is EBS optimized | `bool` | `true` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Whether to enable detailed monitoring for the node | `bool` | `true` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of instance to use for the node | `string` | `"t3.large"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS CMK to use for Encryption | `string` | `""` | no |
| <a name="input_prometheus_ingress_cidrs"></a> [prometheus\_ingress\_cidrs](#input\_prometheus\_ingress\_cidrs) | Comma-delimited list of CIDR blocks from which to allow Prometheus traffic on | `string` | `"0.0.0.0/0"` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | Size of root volume of the node | `number` | `8` | no |
| <a name="input_route53_record_name"></a> [route53\_record\_name](#input\_route53\_record\_name) | Name of the record to create | `string` | `""` | no |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | ID of the Route 53 Zone to create record in | `string` | `""` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID off Subnet to deploy node in | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of VPC to deploy node in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config_bucket_name"></a> [config\_bucket\_name](#output\_config\_bucket\_name) | Name of S3 bucket used to storage config |
| <a name="output_data_volume_id"></a> [data\_volume\_id](#output\_data\_volume\_id) | ID of EBS volume used for data storage |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | IAM role name |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | EC2 Instance ID |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Security Group ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
