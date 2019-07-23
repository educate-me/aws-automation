terraform {
  backend "s3" {
    bucket = "iac.centralized.statefiles"
    key    = "educate-me/aws-iac/terraform/aws-networking/"
    region = "us-east-1"
  }
}
