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
  name_prefix        = "${var.name}-role-"
  assume_role_policy = data.aws_iam_policy_document.cardano_node_assume_role_policy.json
  tags               = var.tags
}

resource "aws_iam_instance_profile" "cardano_node" {
  name_prefix = "${var.name}-profile-"
  role        = aws_iam_role.cardano_node.name
  tags        = var.tags
}

## ssm managed

resource "aws_iam_role_policy_attachment" "ssm" {
  count      = var.ssm_managed ? 1 : 0
  role       = aws_iam_role.cardano_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

## access config in S3

data "aws_iam_policy_document" "config_access" {
  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      var.config_bucket_arn
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${var.config_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "config_access" {
  name_prefix = "${var.name}-config-policy-"
  policy      = data.aws_iam_policy_document.config_access.json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "config_access" {
  role       = aws_iam_role.cardano_node.name
  policy_arn = aws_iam_policy.config_access.arn
}

## attach EBS volume

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
  name_prefix = "${var.name}-attach-data-volume-policy-"
  policy      = data.aws_iam_policy_document.attach_data_volume.json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "attach_data_volume" {
  role       = aws_iam_role.cardano_node.name
  policy_arn = aws_iam_policy.attach_data_volume.arn
}

## access kms key

data "aws_iam_policy_document" "access_kms_key" {
  statement {
    sid    = "AllowUseOfEncryptionKey"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:ReEncrypt",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = [var.kms_key_arn]
  }

  statement {
    sid    = "AllowCreateGrant"
    effect = "Allow"
    actions = [
      "kms:CreateGrant"
    ]

    resources = [var.kms_key_arn]

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = [true]
    }
  }
}

resource "aws_iam_policy" "access_kms_key" {
  name_prefix = "${var.name}-kms-key-access-policy-"
  policy      = data.aws_iam_policy_document.access_kms_key.json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "access_kms_key" {
  role       = aws_iam_role.cardano_node.name
  policy_arn = aws_iam_policy.access_kms_key.arn
}
