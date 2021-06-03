variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "AWS VPC CIDR block"
  default     = "10.0.0.0/20"
}

variable "public_subnet_azs" {
  type        = map(string)
  description = "AWS Subnets CIDR - Multi AZ for high availability"
  default = {
    "us-east-1a" = "10.0.1.0/24"
    "us-east-1b" = "10.0.2.0/24"
  }
}

variable "http_port" {
  description = "The tcp port -  web server will be listening on"
  type        = number
  default     = 80
}

variable "instance_type" {
  description = "AWS Instance Type for Web Tier"
  type        = string
  default     = "t2.micro"
}

variable "sns_topic_email" {
  type        = string
  description = "Email ID subscription for SNS Topic"
  default     = "manish6385@gmail.com"
}