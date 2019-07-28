module "destination" {
  source = "../../modules/destination"

  providers = {
    "aws" = "aws.secondary"
  }

}

module "source" {
  source = "../../modules/source"
  destination_bucket_arn = "${module.destination.destination_bucket_arn}"

  providers = {
    "aws" = "aws.primary"
  }

}
