resource "aws_subnet" "mrw_public_subnet" {
  vpc_id                  = aws_vpc.mrw_vpc.id
  map_public_ip_on_launch = true

  for_each          = var.public_subnet_azs
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    "Name" = "subnet-${each.key}"
  }
}