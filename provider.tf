terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"

    }
  }
}

provider "aws" {
  region  = var.region
  profile = "g33kzone-devops"
  default_tags {
    tags = {
      "Environment" = "test"
      "Owner"       = "manish warang"
    }
  }
}