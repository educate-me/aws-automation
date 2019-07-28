# IAM Role for s3 to assume for Cross Regional Replication(CRR)
resource "aws_iam_role" "replication" {
  name_prefix = "edume.csaa.aws.iam.assume.crr-"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY

}

# Create IAM Poilicies to grant required access to source and desticnation buckets needed for Cross Regional Replication(CRR)
resource "aws_iam_policy" "replication" {
  name_prefix = "edume.csaa.aws.iam.access.crr-"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${var.destination_bucket_arn}/*"
    }
  ]
}
POLICY

}

# Attach above create policy to the IAM Role created earlier
resource "aws_iam_policy_attachment" "replication" {
  name       = "edume.csaa.aws.iam.role-attachment.crr-"
  roles      = ["${aws_iam_role.replication.name}"]
  policy_arn = "${aws_iam_policy.replication.arn}"

}


# Source Bucket(My Bucket)
resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "edume.csaa.aws.s3.my-bucket-"
  acl           = "private"
  region        = "us-east-1"
  
  # Deletes a bucket even if object(s) are present
  force_destroy = true

  # Enable versioning on bucket
  versioning {
    enabled = true
  }

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

    noncurrent_version_expiration {
      days = 120
    }

  }

  # Cross Region Replcation(CRR)
  replication_configuration {
    role = "${aws_iam_role.replication.arn}"

    rules {
      id     = "edume.csaa.aws.s3.crr"
      status = "Enabled"

      destination {
        bucket        = "${var.destination_bucket_arn}"
        storage_class = "STANDARD"
      }
    }
  }

}
