variable "enabled" {
    description = "Flag to decide if the distribution is enabled to accept end user requests for content."
    type        = bool
    default     = true        
}

variable "ipv6_enabled" {
    description = "Flag to decide if ipv6 is enabled for the distribution."
    type        = bool
    default     = false
}

variable "http_version" {
    description = "The maximum HTTP version to support on the distribution."
    type        = string
    default     = "http2"

    validation {
        condition = contains(["http1.1", "http2", "http2and3", "http3"], var.http_version)
        error_message = "Possible Values are `http1.1`, `http2`, `http2and3 `, `http3`."
    }
}

variable "price_class" {
    description = "The price class for this distribution."
    type        = string
    default     = "PriceClass_All"

    validation {
        condition = contains(["PriceClass_100.1", "PriceClass_200", "PriceClass_All"], var.http_version)
        error_message = "Possible Values are `PriceClass_100`, `PriceClass_200`, `PriceClass_All `."
    }
}

variable "aliases" {
    description = "List of extra CNAMEs (alternate domain names) for this distribution."
    type        = list(string)
    default     = []
}

variable "default_root_object" {
    description = "The object that CloudFront will return when an end user requests the root URL."
    type        = string
    default     = "index.html"
}

variable "retain_on_delete" {
    description = "Flag to decide if disable the distribution instead of deleting it when destroying the resource through Terraform."
    type        = bool
    default     = false
}

variable "wait_for_deployment" {
    description = "Flag to decide if the resource will wait for the distribution status to change from InProgress to Deployed."
    type        = bool
    default     = true
}

variable "web_acl_id" {
    description = "A unique identifier that specifies the AWS WAF web ACL, if any, to associate with the distribution."
    type        = string
    default     = null
}

variable "comments" {
    description = "Any comments to include about the distribution."
    type        = string
    default     = null
}

variable "error_responses" {
    description = <<EOF
List of Map with following key/pairs, for custom Error responses to be configured on CDN.

error_code: (Required) The 4xx or 5xx HTTP status code that you want to customize.
response_code: (Optional) The HTTP status code that you want CloudFront to return with the custom error page to the viewer.
error_caching_min_ttl: (Optional) - The minimum amount of time you want HTTP error codes to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated.
response_page_path: (Optional) - The path of the custom error page.

EOF
    type        = list(map(string))
    default     = []
}

variable "logging" {
    description = <<EOF
Configuration map (with following key-pair) of how logs are written to your distribution.
bucket: (Required) The Amazon S3 bucket to store the access logs in.
include_cookies: (Optional) Specifies whether you want. CloudFront to include cookies in access logs
prefix: An optional string that you want CloudFront to prefix to the access log filenames for this distribution.
EOF
    type = map(string)
    default = {}
}

variable "geo_restrictions" {
    description = <<EOF
(Optional) Configuration map for geo restrictrions:

locations: (Optional) List of the `ISO 3166-1-alpha-2 codes` for which CloudFront will either distribute content (whitelist) or not distribute the content (blacklist).
restriction_type: (Required) Restriction method to use for restrictricting distribution of your content by country
EOF
    type    = any
    default = {}
}

variable "tags" {
  description = "(Optional) A map of tags to assign to the distribution."
  type        = map(string)
  default     = {}
}

variable "create_origin_access_identity" {
    description = "Flag to decide if create an Amazon Cloudfront Origin Access Identity."
    type        = bool
    default     = false
}

variable "oai_comments" {
    description = "An optional comment for the origin access identity."
    type        = string
    default     = null
}

variable "create_cloudfront_public_key" {
    description = "Flag to decide if create CloudFront public key."
    type        = bool
    default     = false
}

variable "cloudfront_public_key" {
    description = <<EOF
Configuration map (with following key-pair) for Public Key.

name: The name for the public key.
file: The encoded public key file (with path relative to root) to add to CloudFront to use with features like field-level encryption.
comments: An optional comment about the public key.
EOF
    type        = map(string)
    default     = {}
}

variable "enable_additional_moniroting" {
    description = "Flag to decide if additional CloudWatch metrics are enabled for a CloudFront distribution."
    type        = bool
    default     = false
}