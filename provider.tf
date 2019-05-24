provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

terraform {
  backend "s3" {
    bucket = "terraformbackend07"
    key = "terraform"
    region = "us-east-1"
  }
}
