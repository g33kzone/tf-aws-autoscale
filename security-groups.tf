resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow inbound HTTP traffic"
  vpc_id      = aws_vpc.mrw_vpc.id

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "Allow inbound HTTP"
  }
}

# resource "aws_security_group" "allow_elb_http" {
#   name        = "allow_elb_http"
#   description = "Allow inbound traffic to instances via ELB"
#   vpc_id      = aws_vpc.mrw_vpc.id

#   ingress {
#     from_port   = var.http_port
#     to_port     = var.http_port
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     "Name" = "Allow inbound ELB HTTP"
#   }
# }

resource "aws_security_group" "allow_alb_http" {
  name        = "allow_alb_http"
  description = "Allow inbound traffic to instances via ALB"
  vpc_id      = aws_vpc.mrw_vpc.id

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "Allow inbound ELB HTTP"
  }
}