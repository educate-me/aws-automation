resource "aws_s3_bucket" "b" {
  bucket_prefix = "edume.aws.csaa.practice-"
  acl           = "private"

  # Enable versioning on bucket
  versioning {
    enabled = true
  }

  # Deletes a bucket even if object(s) are present
  force_destroy = true

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
    Email       = "nikhilbabaria07@gmail.com"
  }

  # Object Lifecycle Management
  # STANDARD_IA
  # ONEZONE_IA
  # GLACIER
  lifecycle_rule {

    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 60
      storage_class = "ONEZONE_IA"
    }

    noncurrent_version_transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 120
    }

  }

}
