resource "aws_ssm_document" "restart" {
  name            = "restart-cardano-node"
  document_format = "YAML"
  document_type   = "Command"
  target_type     = "/AWS::EC2::Instance"

  content = file("${path.module}/docs/restart.yaml")
}

resource "aws_ssm_document" "update" {
  name            = "update-cardano-node"
  document_format = "YAML"
  document_type   = "Command"
  target_type     = "/AWS::EC2::Instance"

  content = templatefile("${path.module}/docs/update.yaml", {
    config_bucket = var.config_bucket_name
  })
}
