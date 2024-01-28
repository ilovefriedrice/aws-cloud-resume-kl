# CloudFront Distribution for the S3 Bucket
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.resume_bucket.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.resume_bucket.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  aliases = ["kevscloud.com", "*.kevscloud.com"]
  
  enabled         = true
  is_ipv6_enabled = true

  default_root_object = "index.html" # The default page that CloudFront returns when a viewer request points to the root URL

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.resume_bucket.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400    # 1 day
    max_ttl                = 31536000 # 1 year
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # SSL/TLS certificate
  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:671931291881:certificate/d9883769-fcc4-4716-b6e9-fef06c6d2135"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  tags = {
    Environment = "production"
  }
}

output "cloudfront_distribution_url" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}

output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}
