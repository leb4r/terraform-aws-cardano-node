provider "aws" {
  region = "us-east-1"
}

module "cardano_node" {
  source = "../../"

  vpc_id                      = data.aws_vpc.default.id
  subnet_id                   = tolist(data.aws_subnet_ids.all.ids)[0]
  associate_public_ip_address = true
}
