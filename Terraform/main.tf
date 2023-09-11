resource "aws_s3_object" "index" {
  bucket       = var.bucketname
  key          = "index.html"
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = var.bucketname
  key          = "error.html"
  source       = "error.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "profile" {
  bucket       = var.bucketname
  key          = "profile.png"
  source       = "profile.png"
  acl          = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = var.bucketname
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}
