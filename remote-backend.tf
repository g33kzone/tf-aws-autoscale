terraform {
  backend "s3" {
    bucket = "web-app-terraform-demo-manish"
    key    = "terraform-tfstate"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "terraform-lock-state"
  }
}