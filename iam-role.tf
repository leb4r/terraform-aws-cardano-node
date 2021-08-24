data "aws_iam_policy_document" "cardano_node_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cardano_node" {
  name_prefix        = "cardano-node-"
  assume_role_policy = data.aws_iam_policy_document.cardano_node_assume_role_policy.json
  tags               = var.tags
}

resource "aws_iam_instance_profile" "cardano_node" {
  name_prefix = "cardano-node-"
  role        = aws_iam_role.cardano_node.name
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.cardano_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "access_config" {
  role       = aws_iam_role.cardano_node.name
  policy_arn = aws_iam_policy.config_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_data_volume" {
  role       = aws_iam_role.cardano_node.name
  policy_arn = aws_iam_policy.attach_data_volume.arn
}

resource "aws_iam_role_policy_attachment" "access_encryption_key" {
  role       = aws_iam_role.cardano_node.name
  policy_arn = aws_iam_policy.encryption_key_access.arn
}
