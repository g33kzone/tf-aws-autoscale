resource "aws_route_table" "mrw_vpc_route_table" {
  vpc_id = aws_vpc.mrw_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mrw_vpc_igw.id
  }

  tags = {
    "Name" = "route tables"
  }
}

resource "aws_route_table_association" "mrw_route_subnet" {
  route_table_id = aws_route_table.mrw_vpc_route_table.id
  for_each       = aws_subnet.mrw_public_subnet
  subnet_id      = each.value.id
}