##########################
## Cloudfront Distribution
##########################
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

variable "enable_additional_moniroting" {
    description = "Flag to decide if additional CloudWatch metrics are enabled for a CloudFront distribution."
    type        = bool
    default     = false
}

variable "tags" {
  description = "(Optional) A map of tags to assign to the distribution."
  type        = map(string)
  default     = {}
}

##########################
## Origins
##########################
variable "origins" {
    description = <<EOF
List of Cloudfront Distribution's Origins Configiration Map with following key-pairs

origin_id: (Required) A unique identifier for the origin.
origin_path: (Optional) Directory in origin from where CloudFront will request the content from.
domain_name: (Required) The DNS domain name of either the S3 bucket, or web site of your custom origin.
connection_attempts: (Optional) The number of times that CloudFront attempts to connect to the origin.
connection_timeout: (Optional) The number of seconds that CloudFront waits when trying to establish a connection to the origin.
origin_access_control_id: (Optional) The unique identifier of a CloudFront origin access control for this origin.

custom_headers: (Optional) The Map of headers (Name/value pairs) to specify header data that will be sent to the origin.
origin_access_identity: The CloudFront origin access identity to associate with the S3 origin.
custom_origin_config: Custom origin Configuration Map with following key-pairs:
        http_port                : (Required) The HTTP port the custom origin listens on.
        https_port               : (Required) The HTTPS port the custom origin listens on.
        origin_protocol_policy   : (Required) The origin protocol policy to apply to your origin.
        origin_ssl_protocols     : (Required) The list of SSL/TLS protocols that CloudFront will use when communicating with origin over HTTPS.
        origin_keepalive_timeout : (Optional) The Custom KeepAlive timeout, in seconds.
        origin_read_timeout      : (Optional) The Custom Read timeout, in seconds.

enable_origin_shield: Flag to decide if origin shield is enabled, help to reduce the load on your origin.
shield_region: The AWS Region (region-code) for Origin Shield.

EOF
    type = any
    
    validation {
        condition = length(var.origins) > 0
        error_message = "At least one origin is required."
    }
}

variable "origin_groups" {
    description = <<EOF
List of Origin Groups Map with the following key-pairs, for the distribution

origin_group_id: (Required) A unique identifier for the origin group.
failover_status_codes: (Required) A list of HTTP status codes for the origin group's failover criteria.
primary_member: (Required) The unique identifier of the primary member origin.
secondary_member: (Required) The unique identifier of the secondary member origin.
EOF
    type = any
    default = []
}

##########################
## Cache Behaviors
##########################
variable "default_cache_behavior" {
    description = <<EOF
The default cache behaviour for the distribution:

target_origin_id: (Required) The value of ID for the origin that CloudFront will use to route requests to, when a request matches the path pattern either for a cache behavior or for the default cache behavior.

viewer_protocol_policy: (Required) The protocol that users can use to access the files in the origin.
path_pattern: (Optional) The pattern (for example, images/*.jpg) that specifies which requests this cache behavior to apply to.

allowed_methods: (Optional) The list of HTTP methods that CloudFront processes and forwards to origin.
cached_methods: (Optional) The list of HTTP methods that CloudFront caches the response to requests for.

compress: (Optional) Flag to decide if CloudFront compress the content automatically for web requests that include Accept-Encoding: gzip in the request header.

default_ttl: (Optional) The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header.
min_ttl: (Optional) The minimum amount of time, the objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated.
max_ttl: (Optional) The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated.

smooth_streaming: (Optional) Indicates whether you want to distribute media files in Microsoft Smooth Streaming format.
realtime_log_config_arn: (Optional) The ARN of the existing Realtime log configuration.
realtime_log_config_name: (Optional) The name of the Realtime log configuration (as defined in `realtime_log_configs`).
encryption_profile_arn: (Optional) The ARN of the existing Field Level Encryption Profile.
encryption_profile_name: (Optional) The name of the Field Level Encryption Profile (as defined in `encryption_profiles`).
trusted_signers: (Optional) List of AWS account IDs (or self) that you want to allow to create signed URLs for private content.
trusted_key_group_arns: (Optional) List of ARN for existing trusted Key Groups, if the distribution is set up to serve private content with signed URLs.
trusted_key_group_names: (Optional) List of trusted Key Group Names (as defined in the `key_groups`), if the distribution is set up to serve private content with signed URLs.

origin_request_policy_arn: (Optional) The ARN of the existing Origin Request Policy that is attached to the behavior (as defined in `origin_request_policy`).
origin_request_policy_name: (Optional) The name of the Origin Request Policy that is attached to the behavior (as defined in `origin_request_policy`).
cache_policy_arn: (Optional) The ARN of the existing Cache policy that is attached to the cache behavior (as defined in `cache_policy`).
cache_policy_name: (Optional) The name of the Cache policy that is attached to the cache behavior (as defined in `cache_policy`).
response_headers_policy_arn: (Optional) The ARN of the existing Response Header Policy that is attached to the cache behavior (as defined in `response_headers_policy`).
response_headers_policy_name: (Optional) The name of the Response Header Policy that is attached to the cache behavior (as defined in `response_headers_policy`).

## forwarded_values properties
handle_forwarding: (Optional) Flag to decide if thoe configuration should be done how the Cloudfront should handle the query strings, cookies and headers.
cookie_behavior: (Optional) Determines if CloudFront forward cookies to the origin.
cookies_items: (Optional) Comma seperated List of Cookie names that CloudFront forward to your origin.
headers: (Optional) Comma seperated List of Header names that CloudFront forward to your origin.
query_strings: (Optional) Flag to decide if CloudFront forward Query string to the origin.
query_strings_cache_keys: (Optional) Comma seperated List of Query strings which will be cahced.

edge_lambda_functions: (Optional) Map of Lambda functions that Cloudfront can trigger on a predefined event.
    Map-key: Event Name (`viewer-request`, `origin-request`, `viewer-response`, `origin-response`)
    Map-Value: Nested map with Lambda function configuration:
        arn: ARN of the Lambda function.
        include_body: (Optional) When set to true it exposes the request body to the lambda function.

cloudfront_functions: (Optional) Map of Cloudfront Functions
    Map Key - Event Name (`viewer-request`, `viewer-response`)
    Map vaue - Cloudfront function name as defined in `cloudfront_functions`
    
EOF
    type = any
}

variable "ordered_cache_behaviors" {
    description = "List of configuration map of Cache behaviours for the distribution where each entry will be of the same strcuture as `default_cache_behavior`"
    type = any
    default = []
}

##########################
## Viewer Certificate 
##########################
variable "cloudfront_default_certificate" {
    description = "Flag to decide to use HTTPS to request your objects and you're using the CloudFront domain name for your distribution."
    type        = bool
    default     = true
}

variable "acm_certificate_arn" {
    description = "The ARN of the ACM certificate in `us-east-1` region to use with this distribution."
    type        = string
    default     = null
}

variable "iam_certificate_id" {
    description = "The IAM certificate identifier of the custom viewer certificate for this distribution if you are using a custom domain."
    type        = string
    default     = null   
}

variable "minimum_protocol_version" {
    description = "The minimum version of the SSL protocol, CloudFront to use for HTTPS connections if `cloudfront_default_certificate` is set `false`."
    type        = string
    default     = "TLSv1"    
}

variable "ssl_support_method" {
    description = "Specifies how you want CloudFront to serve HTTPS requests."
    type        = string
    default     = null
}

##########################
## Policies
##########################
variable "cache_policies" {
    description = <<EOF
List of Configuration Map (with the following properties) for Cache Policies to be provisioned.

name: (Required) Unique name to identify the cache policy.
comments: (Optional) Comment to describe the cache policy.

default_ttl: (Optional) The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront sends another request to the origin to determine whether the object has been updated.
min_ttl: (Optional) The minimum amount of time, the objects to stay in CloudFront caches before CloudFront sends another request to the origin to see whether the object has been updated.
max_ttl: (Optional) The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront sends another request to the origin to determine whether the object has been updated.

cookie_behavior: (Optional) Determines whether any cookies in viewer requests are included in the cache key and automatically included in requests that CloudFront sends to the origin.
cookies_items: (Optional) Comma seperated List of Cookie names.

header_behavior: (Optional) Determines whether any HTTP headers are included in the cache key and automatically included in requests that CloudFront sends to the origin. 
headers_items: (Optional) Comma seperated List of header names.

query_string_behavior: (Optional) Determines whether any URL query strings in viewer requests are included in the cache key and automatically included in requests that CloudFront sends to the origin.
query_strings_items: (Optional) Comma seperated List of query strings.

enable_accept_encoding_brotli: (Optional) A flag that can affect whether the Accept-Encoding HTTP header is included in the cache key and included in requests that CloudFront sends to the origin.
enable_accept_encoding_gzip: (Optional) A flag that can affect whether the Accept-Encoding HTTP header is included in the cache key and included in requests that CloudFront sends to the origin.
EOF
    type    = any
    default = []
}

variable "origin_request_policies" {
    description = <<EOF
List of Configuration Map (with the following properties) for Origin Request Policies to be provisioned.

name: (Required) Unique name to identify the origin request policy.
comments: (Optional) Comment to describe the origin request policy.

cookie_behavior: (Optional) Determines whether any cookies in viewer requests are included in the origin request key and automatically included in requests that CloudFront sends to the origin.
cookies_items: (Optional) Comma seperated List of Cookie names.

header_behavior: (Optional) Determines whether any HTTP headers are included in the origin request key and automatically included in requests that CloudFront sends to the origin. 
headers_items: (Optional) Comma seperated List of header names.

query_string_behavior: (Optional) Determines whether any URL query strings in viewer requests are included in the origin request key and automatically included in requests that CloudFront sends to the origin.
query_strings_items: (Optional) Comma seperated List of query strings.

EOF
    type    = any
    default = []
}

variable "response_headers_policies" {
    description = <<EOF
List of Configuration Map (with the following properties) for Response Headers Policies to be provisioned.

name: (Required) Unique name to identify the Response Headers policy.
comments: (Optional) Comment to describe the Response Headers policy.

## CORS configurations
configure_cors: (Optional) Flag to decide if Cross-Origin Resource Sharing should be configured.
access_control_allow_credentials: The boolean flag that CloudFront uses as the value for the `Access-Control-Allow-Credentials` HTTP response header.
origin_override: (Optional) Flag to decide how CloudFront behaves for the HTTP response header.
max_age: (Optional) A number that CloudFront uses as the value for the `Access-Control-Max-Age` HTTP response header.
allowed_origins: (Optional) List of origins that CloudFront can use as the value for the `Access-Control-Allow-Origin` HTTP response header.
allowed_headers: (Optional) List of HTTP header names that CloudFront includes as values for the `Access-Control-Allow-Headers` HTTP response header.
allowed_methods: (Optional) List of HTTP methods that CloudFront includes as values for the `Access-Control-Allow-Methods` HTTP response header.
exposed_headers: (Optional) List of HTTP headers that CloudFront includes as values for the `Access-Control-Expose-Headers` HTTP response header.

## Security Headers
configure_strict_transport_security: (Optional) Flag to decide if configure `Strict-Transport-Security` response header.
strict_transport_security: (Optional) Map of `Strict-Transport-Security` response header configuration
    max_age_sec: (Optional) A number that CloudFront uses as the value for the `max-age` directive in the `Strict-Transport-Security` HTTP response header.
    include_subdomains: (Optional) Flag to decide if CloudFront includes the `includeSubDomains` directive in the `Strict-Transport-Security` HTTP response header.
    origin_override: (Optional) Flag to decide if CloudFront overrides the `Strict-Transport-Security` HTTP response header received from the origin with the one specified in this response headers policy.
    preload: (Optional) Flag to decide if CloudFront includes the preload directive in the `Strict-Transport-Security` HTTP response header.

configure_content_type_options: (Optional) Flag to decide if CloudFront adds the `X-Content-Type-Options` header to responses.
content_type_options_override_origin: Flag to decide if Cloudfront overrides the `X-Content-Type-Options` HTTP response header received from the origin with the one specified in this response headers policy.

configure_frame_options: (Optional) Flag to decide if CloudFront adds the `X-Frame-Options` header to responses.
frame_option: (Optional) The value of the `X-Frame-Options` HTTP response header.
frame_options_override_origin: (Optional) Flag to decide if Cloudfront overrides the `X-Frame-Options` HTTP response header received from the origin with the one specified in this response headers policy.

configure_xss_protection: (Optional) Flag to decide if configure `X-XSS-Protection` response header.
xss_protection: (Optional) Map of `X-XSS-Protection` response header configuration
    mode_block: (Optional) Flag to decide if CloudFront includes the `mode=block` directive in the X-XSS-Protection header.
    override_origin: (Optional) Flag to decide if CloudFront overrides the `X-XSS-Protection` HTTP response header received from the origin with the one specified in this response headers policy.
    protection: (Optional) Flag to decide if protection is enabled.
    report_uri: (Optional) A reporting URI, which CloudFront uses as the value of the report directive in the X-XSS-Protection header.

configure_referrer_policy: (Optional) Flag to decide if configure `Referrer-Policy` response header.
referrer_policy: (Optional) Map of `Referrer-Policy` response header configuration
    policy: (Optional) The value of the `Referrer-Policy` HTTP response header.
    override_origin: (Optional) Flag to decide if CloudFront overrides the `Referrer-Policy` HTTP response header received from the origin with the one specified in this response headers policy.

configure_content_security_policy: (Optional) Flag to decide if configure `Content-Security-Policy` response header.
content_security_policy: (Optional) Map of `Content-Security-Policy` response header configuration
    policy: (Optional) The value of the `Content-Security-Policy` HTTP response header.
    override_origin: (Optional) Flag to decide if CloudFront overrides the `Content-Security-Policy` HTTP response header received from the origin with the one specified in this response headers policy.

## Custom Headers
custom_headers: (Optional) List of Map (with the following properties) for Custom Headers.
    header: (Required) The HTTP response header name.
    value: (Required) The value for the HTTP response header.
    override_origin: (Optional) Flag to decide if CloudFront overrides a response header with the same name received from the origin with this header.

## Server-Timing Header
enable_server_timing_header: (Optional) FLag to decide if Cloudfront show set `Server-Timing` header in HTTP responses.
sampling_rate: (Optional) A number 0–100 (inclusive) that specifies the percentage of responses that you want CloudFront to add the Server-Timing header to. 
EOF
    type    = any
    default = []
}

##########################
## Cloudfront Functions
##########################
variable "cloudfront_functions" {
    description = <<EOF
List of Configurations Map for the cloudfront functions to be provisioned:
name: (Required) Unique name for your CloudFront Function.
runtime: (Required) Identifier of the function's runtime.
comment: (Optional) Comment.
publish: (Optional) Whether to publish creation/change as Live CloudFront Function Version.
code_file: (Required) Source code File of the function (Path relative to root directory)
EOF

    type = any
    default = []
}

##########################################
## Telemetry: Realtime Logs Configuration
##########################################
variable "realtime_log_configs" {
    description = <<EOF
List of Configuration Maps for CloudFront real-time log:
name            : (Required) The unique name to identify this real-time log configuration.
sampling_rate   : (Required) The sampling rate for this real-time log configuration.
fields          : (Required) The fields that are included in each real-time log record.
stream_arn      : (Required) The ARN of the Kinesis data stream where real-time log data is sent.
role_arn        : (Optional) The ARN of an IAM role that CloudFront can use to send real-time log data to the Kinesis data stream.
EOF
}

variable "create_realtime_logging_role" {
    description = "Flag to decide if IAM role needs to be provisioned that CloudFront can use to send real-time log data to the Kinesis data streams."
    type        = bool
    default     = true
}

variable "realtime_logging_role" {
    description = "IAM Role Name to be provisioned that CloudFront can use to send real-time log data to the Kinesis data streams."
    type        = string
    default     = null
}

##########################
## Cloudfront Security
##########################
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

variable "encryption_profiles" {
    description = <<EOF
List of Configuration Map (with the following properties) for Field Level Encryption Profiles to be provisioned.

name: (Required) Unique name to identify the Field Level Encryption Profile.
comments: (Optional) Comments to describe the Field Level Encryption Profile.

key_name: (Required) Public Key Name (as defined in `public_keys`), to be used when encrypting the fields that match the patterns.
provider_id: (Required) The provider associated with the public key being used for encryption.
field_patterns: (Requried) The list of field patterns to specify the fields that should be encrypted.

EOF
    type    = any
    default = []
}

##########################
## Key Management
##########################
variable "public_keys" {
    description = <<EOF
List of Configuration map (with following key-pair) for Public Keys.

name: (Required) The name for the public key.
comments: (Optional) Any comments about the public key.
key_file: (Required) The encoded public key file (with path relative to root) to add to CloudFront to use with features like field-level encryption.
EOF
    type        = list(map(string))
    default     = []
}

variable "key_groups" {
    description = <<EOF
List of Configuration map (with following key-pair) for Public Keys.

name: (Required) The name for the public key.
comments: (Optional) Any comments about the public key.
keys: (Required) The comma separated list of key names (as defined in `public_keys`)
EOF
    type        = list(map(string))
    default     = []
}