terraform {
  backend "s3" {
    bucket  = "djtf-state-bucket"
    key     = "state-files/terraform.tfstate"
    region  = "us-east-2"
    profile = "tfuser"
  }
}