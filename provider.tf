provider "aws" {
  region      = var.aws_region
  access_key  = "AKIA2TKDVQWTP4GYTBKO"
  secret_key  = "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"
}

/*
terraform {
  backend = "terraform-s3-bucket"
  key = "eks/terraform-tfstate"
  region = var.aws_region
}
*/