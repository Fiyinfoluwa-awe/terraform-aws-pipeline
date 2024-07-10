provider "aws" {
  region = local.region
}

terraform {
  backend "s3" {
    bucket = "dherby-cicd-class"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}