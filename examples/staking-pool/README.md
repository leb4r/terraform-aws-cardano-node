# Staking Pool Example

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_block_producer"></a> [block\_producer](#module\_block\_producer) | ../../ | n/a |
| <a name="module_dns"></a> [dns](#module\_dns) | terraform-aws-modules/route53/aws//modules/zones | 2.1.0 |
| <a name="module_encryption_key"></a> [encryption\_key](#module\_encryption\_key) | cloudposse/kms-key/aws | 0.10.0 |
| <a name="module_relay_node"></a> [relay\_node](#module\_relay\_node) | ../../ | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.2.0 |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_block_producer_ids"></a> [block\_producer\_ids](#output\_block\_producer\_ids) | List of EC2 instance IDs of the block producing nodes |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | ID of KMS CMK used for encryption-at-rest |
| <a name="output_relay_ids"></a> [relay\_ids](#output\_relay\_ids) | List of instance IDs of the relay nodes |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of VPC |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
