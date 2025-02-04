#Create bucket

resource "aws_s3_bucket" "my-bucket" {
  bucket = "var.bucketname"

}

#
resource "aws_s3_bucket_ownership_controls" "my-bucket" {
  bucket = aws_s3_bucket.my-bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#Making the bucket publicly accessible
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.my-bucket.id
  acl    = "public"
}

#S3 objects
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.my-bucket.id
  key          = "index.html"
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.my-bucket.id
  key          = "error.html"
  source       = "error.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "tech" {
  bucket = aws_s3_bucket.my-bucket.id
  key    = "tech.png"
  source = "tech.png"
  acl    = "public-read"
}

#website bucket configuration
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.my-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [aws_s3_bucket_acl.example_bucket_acl]
}


