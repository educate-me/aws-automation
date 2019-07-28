terraform {
  backend "s3" {
    bucket = "iac.centralized.statefiles"
    key    = "educate-me/aws-iac/terraform/storage/terraform.state"
    region = "us-east-1"
  }
}