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

## Policies

#### Cache Policy
output "cache_policies" {
    description = "The Map of attributes for Cache Policies."
    value       = { for name, policy in aws_cloudfront_cache_policy.this:
                            name => {
                                id = policy.id
                                etag  = policy.etag
                            }}
}

#### Origin Request Policy
output "origin_request_policies" {
    description = "The Map of attributes for Origin Request Policies."
    value       = { for name, policy in aws_cloudfront_origin_request_policy.this:
                            name => {
                                id = policy.id
                                etag  = policy.etag
                            }}
}

#### Response Headers Policy
output "response_headers_policies" {
    description = "The Map of attributes for Response Headers Policies."
    value       = { for name, policy in aws_cloudfront_response_headers_policy.this:
                            name => {
                                id = policy.id
                                etag  = policy.etag
                            }}
}

## Cloudfront Functions
output "functions" {
    description = "The Map of attributes for Cloudfront Function."
    value       = { for name, function in aws_cloudfront_function.this:
                            name => {
                                arn = function.arn
                                etag  = function.etag
                                status  = function.status
                            }}
}

## Telemetry
output "monitoring_subscription_id" {
    description = "The ID of the CloudFront monitoring subscription."
    value       = aws_cloudfront_monitoring_subscription.this.id
}

#### Realtime Log Configurations
output "realtime_log_configs" {
    description = "The map of Attributes for Realtime Log Configurations."
    value       = { for name, config in aws_cloudfront_realtime_log_config.this:
                            name => {
                                id = config.id
                                etag  = config.arn
                            }}
}

output "log_configuration_role" {
    description = "The ARN of an IAM role that CloudFront can use to send real-time log data to the Kinesis data stream."
    value       = var.create_realtime_logging_role ? aws_iam_role.this[0].arn : ""
}

## Security

### Origin Access Identity
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

## Key Management

### Public Keys
output "public_keys" {
    description = "The Map of attributes for Public Keys."
    value       = { for name, key in aws_cloudfront_public_key.this:
                            name => {
                                id = key.id
                                etag  = key.etag
                            }}
}

### Key Groups
output "key_groups" {
    description = "The Map of attributes for Key Groups."
    value       = { for name, group in aws_cloudfront_key_group.this:
                            name => {
                                id = group.id
                                etag  = group.etag
                            }}
}
