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

## cloudwatch logs

# see https://docs.docker.com/config/containers/logging/awslogs/#credentials
data "aws_iam_policy_document" "cloudwatch_access" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch_access" {
  name_prefix = "${var.name}-cloudwatch-policy-"
  policy      = data.aws_iam_policy_document.cloudwatch_access.json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "cloudwatch_access" {
  role       = aws_iam_role.cardano_node.name
  policy_arn = aws_iam_policy.cloudwatch_access.arn
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
