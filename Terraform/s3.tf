# S3 Bucket
resource "aws_s3_bucket" "resume_bucket" {
  bucket = "cloudresumechallenge-kl"

  tags = {
    Name        = "resume_bucket"
    Environment = "Dev"
  }
}

# Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "resume_bucket_public_access_block" {
  bucket = aws_s3_bucket.resume_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "resume_bucket_ownership_controls" {
  bucket = aws_s3_bucket.resume_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Bucket ACL
resource "aws_s3_bucket_acl" "resume_bucket_acl" {
  bucket = aws_s3_bucket.resume_bucket.id
  acl    = "private"
}

# CloudFront Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${aws_s3_bucket.resume_bucket.id}"
}

# Bucket Policy for CloudFront
resource "aws_s3_bucket_policy" "resume_bucket_policy" {
  bucket = aws_s3_bucket.resume_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "s3:GetObject"
        Effect    = "Allow"
        Resource  = "${aws_s3_bucket.resume_bucket.arn}/*"
        Principal = { AWS = "${aws_cloudfront_origin_access_identity.oai.iam_arn}" }
      }
    ]
  })
}
