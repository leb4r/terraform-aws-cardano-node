resource "aws_ebs_volume" "this" {
  availability_zone = data.aws_subnet.this.availability_zone
  size              = var.data_volume_size
  encrypted         = var.ebs_encrypted
  kms_key_id        = var.ebs_kms_key_id
  tags              = var.tags
}

data "aws_iam_policy_document" "attach_data_volume" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:AttachVolume",
      "ec2:DetachVolume"
    ]
    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:instance/*"
    ]
  }
}

resource "aws_iam_policy" "attach_data_volume" {
  name_prefix = "cardano-node-attach-data-volume-"
  policy      = data.aws_iam_policy_document.attach_data_volume.json
  tags        = var.tags
}
