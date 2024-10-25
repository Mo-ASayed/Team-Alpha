# backend 
terraform {
  backend "s3" {
    bucket  = "threat-model-bucket"
    key     = "state"
    region  = "eu-west-2"
    encrypt = true
  }
}