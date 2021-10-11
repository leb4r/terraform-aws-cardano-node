# Staking Pool Example

This example demonstrates how a staking pool could be deployed using the [modules](../../modules). At a high-level, this deploys four separate instances, two block producers, and two relay nodes.

Shared infrastructure is used where it makes sense, things like the KMS key, backup plan, VPC, DNS, and log group are all shared amongst the block producers and relay nodes.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backups"></a> [backups](#module\_backups) | ../../modules/backup | n/a |
| <a name="module_block_producer"></a> [block\_producer](#module\_block\_producer) | ../../modules/node | n/a |
| <a name="module_block_producer_config"></a> [block\_producer\_config](#module\_block\_producer\_config) | ../../modules/config | n/a |
| <a name="module_block_producer_iam"></a> [block\_producer\_iam](#module\_block\_producer\_iam) | ../../modules/iam | n/a |
| <a name="module_dns"></a> [dns](#module\_dns) | terraform-aws-modules/route53/aws//modules/zones | 2.1.0 |
| <a name="module_encryption_key"></a> [encryption\_key](#module\_encryption\_key) | ../../modules/kms | n/a |
| <a name="module_logs"></a> [logs](#module\_logs) | ../../modules/logs | n/a |
| <a name="module_relay_config"></a> [relay\_config](#module\_relay\_config) | ../../modules/config | n/a |
| <a name="module_relay_iam"></a> [relay\_iam](#module\_relay\_iam) | ../../modules/iam | n/a |
| <a name="module_relay_node"></a> [relay\_node](#module\_relay\_node) | ../../modules/node | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.2.0 |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_block_producer_ids"></a> [block\_producer\_ids](#output\_block\_producer\_ids) | List of EC2 instance IDs of the block producing nodes |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | ARN of KMS CMK used for encryption |
| <a name="output_relay_ids"></a> [relay\_ids](#output\_relay\_ids) | List of instance IDs of the relay nodes |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of VPC |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
