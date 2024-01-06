resource "aws_s3_bucket" "app_bucket" {
  bucket        = var.app_s3_bucket
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "app_bucket_versioning" {
  bucket = aws_s3_bucket.app_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
