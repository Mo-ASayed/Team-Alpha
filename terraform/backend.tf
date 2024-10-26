# backend 
terraform {
  required_version = ">= 1.0.0"  # Adjust as needed for your environment
  backend "s3" {
    bucket  = "threat-model-bucket"
    key     = "state"
    region  = "eu-west-2"
    encrypt = true
  }
}