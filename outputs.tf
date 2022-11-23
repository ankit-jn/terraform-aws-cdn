output "id" {
    description = "The identifier for the distribution."
    value       = aws_cloudfront_distribution.this.id
}

output "arn" {
    description = "The ARN (Amazon Resource Name) for the distribution."
    value       = aws_cloudfront_distribution.this.arn
}

output "status" {
    description = "The current status of the distribution."
    value       = aws_cloudfront_distribution.this.status
}

output "domain_name" {
    description = "The domain name corresponding to the distribution."
    value       = aws_cloudfront_distribution.this.domain_name
}

output "hosted_zone_id" {
    description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to."
    value       = aws_cloudfront_distribution.this.hosted_zone_id
}

## Origin Access Identity
output "oai_etag" {
    description = "Current version of the origin access identity's information."
    value       = aws_cloudfront_origin_access_identity.this.etag
}

output "oai_iam_arn" {
    description = "Pre-generated ARN for use in S3 bucket policies."
    value       = aws_cloudfront_origin_access_identity.this.iam_arn
}

output "oai_path" {
    description = "A shortcut to the full path for the origin access identity to use in CloudFront."
    value       = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
}

## Cloudfront Public Key
output "public_key_id" {
    description = "The identifier for the public key."
    value       = aws_cloudfront_public_key.this.id
}

output "public_key_etag" {
    description = "The current version of the public key."
    value       = aws_cloudfront_public_key.this.etag
}

output "monitoring_subscription_id" {
    description = "The ID of the CloudFront monitoring subscription."
    value       = aws_cloudfront_monitoring_subscription.this.id
}

## Origin Request Policy
output "origin_request_policies" {
    description = "The Attributes for Origin Request Policies."
    value       = { for key, policy in aws_cloudfront_origin_request_policy.this:
                            key => {
                                id = policy.id
                                etag  = policy.etag
                            }}
}


## Origin Request Policy
output "cache_policies" {
    description = "The Attributes for Cache Policies."
    value       = { for key, policy in aws_cloudfront_cache_policy.this:
                            key => {
                                id = policy.id
                                etag  = policy.etag
                            }}
}