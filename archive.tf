terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2" #or nearer
}

resource "aws_s3_bucket" "media-archive-bucket" {
  bucket = "my-media-archive"
  acl    = "private" #?authenticated-read? or grant?

  lifecycle_rule {
    id      = "media"
    prefix = "media/"
    enabled = true

    tags = {
      rule      = "media"
      autoclean = "true"
    }

    transition {
      days          = 7
      storage_class = "GLACIER"
    }

    transition {
      days          = 365
      storage_class = "DEEP_ARCHIVE"
    }
  }
}
