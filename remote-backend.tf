terraform {
  backend "s3" {
    bucket = "web-app-terraform-demo-6385"
    key    = "terraform-tfstate"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "terraform-lock-state"
  }
}