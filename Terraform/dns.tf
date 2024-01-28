# Create a Route53 Hosted Zone
resource "aws_route53_zone" "kevscloud_zone" {
  name = "kevscloud.com"
}

# A Record for the root domain
resource "aws_route53_record" "root_domain" {
  zone_id = aws_route53_zone.kevscloud_zone.zone_id
  name    = "kevscloud.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# A Record for the wildcard subdomain
resource "aws_route53_record" "wildcard_subdomain" {
  zone_id = aws_route53_zone.kevscloud_zone.zone_id
  name    = "*.kevscloud.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

