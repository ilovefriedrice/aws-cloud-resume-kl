locals {
  content_types = {
    "html" = "text/html",
    "js"   = "application/javascript",
    "css"  = "text/css",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "jpeg" = "image/jpeg",
    "pdf"  = "application/pdf"
    // Add other content types as needed
  }
}

# S3 Bucket
resource "aws_s3_bucket" "resume_bucket" {
  bucket = "cloudresumechallenge-kl-test"
  

  tags = {
    Name        = "resume_bucket"
    Environment = "Dev"
  }
}

# Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "resume_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.resume_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "resume_bucket_ownership_controls" {
  bucket = aws_s3_bucket.resume_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# CloudFront Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${aws_s3_bucket.resume_bucket.id}"
}

# Bucket Policy for CloudFront
resource "aws_s3_bucket_policy" "resume_bucket_policy" {
  bucket = aws_s3_bucket.resume_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "PolicyForCloudFrontPrivateContent",
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.oai.id}"
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.resume_bucket.arn}/*"
      },
      {
        Sid    = "AllowUserToUploadObjects",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::671931291881:user/kevinlibrata"
        },
        Action   = "s3:PutObject",
        Resource = "${aws_s3_bucket.resume_bucket.arn}/*"
      }
    ]
  })
}

# Upload website files to S3 Bucket
resource "aws_s3_object" "website_files" {
  for_each     = { for k, v in fileset("${path.module}/website", "*.*") : k => v if !contains([".DS_Store", ".gitattributes"], v) }
  bucket       = aws_s3_bucket.resume_bucket.id
  key          = each.value
  source       = "${path.module}/website/${each.value}"
  #acl          = "public-read"
  content_type = local.content_types[lower(split(".", each.value)[length(split(".", each.value)) - 1])]
  depends_on   = [
    aws_s3_bucket_public_access_block.resume_bucket_public_access_block,
    aws_s3_bucket_ownership_controls.resume_bucket_ownership_controls,
    aws_s3_bucket_policy.resume_bucket_policy
  ]
}

# Upload assets to S3 Bucket
resource "aws_s3_object" "assets" {
  for_each     = { for k, v in fileset("${path.module}/website/assets", "**/*") : k => v if !contains([".DS_Store", ".gitattributes"], v) }
  bucket       = aws_s3_bucket.resume_bucket.id
  key          = "assets/${each.value}"
  source       = "${path.module}/website/assets/${each.value}"
  #acl          = "public-read"
  content_type = local.content_types[lower(split(".", each.value)[length(split(".", each.value)) - 1])]
  depends_on   = [
    aws_s3_bucket_public_access_block.resume_bucket_public_access_block,
    aws_s3_bucket_ownership_controls.resume_bucket_ownership_controls,
    aws_s3_bucket_policy.resume_bucket_policy
  ]
}

