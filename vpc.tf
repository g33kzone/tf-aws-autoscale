resource "aws_vpc" "mrw_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    "Name" = "vpc"
  }
}

resource "aws_internet_gateway" "mrw_vpc_igw" {
  vpc_id = aws_vpc.mrw_vpc.id

  tags = {
    "Name" = "internet gateway"
  }
}

