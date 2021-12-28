/*
### For S3 Bucker creation and Enabling Vesioning
resource "aws_s3_bucket" "dev-hnk-s3-bucket" {
    bucket = var.s3-bucket-sw
    acl = "${var.acl_value}"
    website {
      index_document = "index.html"
      error_document = "index.html"
    }
    versioning {
      enabled = true
  }
  tags = {
    "Name" = "HNK-S3-BUCKET-PHASE3"
    "Environment" = "Devolepment"
  }
### Life cycle rule                       --> ### need expire/delete after 7 days with non current version
lifecycle_rule {
  id = "Remove-Old-Objects"
  enabled = true
expiration {
  expired_object_delete_marker = true
}
noncurrent_version_expiration {
			days = 1
    }
  }
}

### Bucket policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.dev-hnk-s3-bucket.id

#policy = <<EOF
policy = jsonencode({
  Version: "2012-10-17",
  Id: "SourceIP",
  Statement: [
    {
      Sid: "SourceIP",
      Effect: "Allow",
      Principal: "*",
      Action: "s3:*",
      Resource: "arn:aws:s3:::${var.s3-bucket-sw}/*",
      Condition: {
        IpAddress: {
          #"aws:SourceIp": ["65.0.84.23/32","118.143.50.50/32","52.77.80.140/32","18.142.150.165/32"]
          "aws:SourceIp": ["65.0.84.23/32"]
        }
      }
    }
  ]
})
}


*/