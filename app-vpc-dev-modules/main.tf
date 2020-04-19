provider "aws" {
  region = var.region
}

variable "owner" {}

variable "env" {}

variable "azs" {
  type = list(string)
}

variable "region" {}

resource "random_id" "environment_name" {
  byte_length = 4
  prefix      = "${var.env}-"
}

module "vpc" {
  source             = "tfe.couchtocloud.com/tfe-ghm-tfe-org/vpc/aws"
  version            = "2.34.0"
  name               = random_id.environment_name.hex
  cidr               = "10.10.0.0/16"
  azs                = var.azs
  private_subnets    = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets     = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
  database_subnets   = ["10.10.201.0/24", "10.10.202.0/24", "10.10.203.0/24"]
  enable_nat_gateway = true
  enable_vpn_gateway = false
  tags = {
    owner = var.owner
  }
}
