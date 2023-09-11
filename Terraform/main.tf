#Creating and updating the S3 bucket in AWS
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucketname
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.my_bucket.id
  acl    = "public-read"
}

#Adding ACL to the bucket policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.bucketname  # Replace with your bucket name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "Enable ACLs",
        Effect    = "Allow",
        Principal = "*",
        Action    = [
          "s3:PutBucketAcl",
          "s3:GetBucketAcl",
        ],
        Resource  = aws_s3_bucket.my_bucket.arn,  # Replace with your bucket ARN in TF
      },
    ],
  })
  depends_on = [aws_s3_bucket.my_bucket, aws_s3_bucket_ownership_controls.example, aws_s3_bucket_public_access_block.example,aws_s3_bucket_acl.example, ]
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.my_bucket.id
  key = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
  depends_on = [ aws_s3_bucket_policy.bucket_policy ]
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.my_bucket.id
  key = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
  depends_on = [ aws_s3_bucket_policy.bucket_policy ]
}

resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.my_bucket.id
  key = "profile.png"
  source = "profile.png"
  acl = "public-read"
  depends_on = [ aws_s3_bucket_policy.bucket_policy ]
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.my_bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
  depends_on = [ aws_s3_bucket_acl.example ]
}
