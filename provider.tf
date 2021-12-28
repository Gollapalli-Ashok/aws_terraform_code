provider "aws" {
  region      = var.aws_region
  access_key  = ""
  secret_key  = ""
}

/*
terraform {
  backend = "terraform-s3-bucket"
  key = "eks/terraform-tfstate"
  region = var.aws_region
}
*/
