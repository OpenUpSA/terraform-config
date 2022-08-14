terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_iam_user" "gov-za-scraper" {
  name = "gov-za-scraper"
}

resource "aws_iam_access_key" "access_key_id" {
  user = "gov-za-scraper"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "gov-za-scrape"
  tags = {
    project = "gov-za-scraper"
  }
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  acl = "private"
}

resource "aws_iam_policy" "policy" {
  name        = "gov-za-scrape-bucket-policy"
  description = "Scraper can do all operations on its bucket"
  tags = {
    project = "gov-za-scraper"
  }

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListAllMyBuckets"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.bucket.arn}"
    },
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.bucket.arn}/*"
    }
  ]
}
EOT
}

resource "aws_iam_user_policy_attachment" "attachment" {
  user       = aws_iam_user.gov-za-scraper.name
  policy_arn = aws_iam_policy.policy.arn
}