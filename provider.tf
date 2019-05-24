provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAJ6LBJ22BRH4ZANDA"
  secret_key = "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"
}

terraform {
  backend "s3" {
    bucket = "terraformbackend07"
    key = "terraform"
    region = "us-east-1"
  }
}
