## ARJ-Stack: AWS Cloudfront Distribution Network (CDN) Terraform module

A Terraform module for configuring Content Delivery Network in AWS

### Resources
This module features the following components to be provisioned:

- Cloudfront Distribution [[aws_cloudfront_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution)]
- Origin Request Policy [[aws_cloudfront_origin_request_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_request_policy)]
- Cache Policy [[aws_cloudfront_cache_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_cache_policy)]
- Origin Access Identity [[aws_cloudfront_origin_access_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity)]
- Cloudfront Public Key [[aws_cloudfront_public_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_public_key)]
- Additional Cloudwatch Monitoring for CDN [[aws_cloudfront_monitoring_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_monitoring_subscription)]
- Cloudfront Function [[aws_cloudfront_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_function)]

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.22.0 |

### Examples

Refer [Configuration Examples](https://github.com/arjstack/terraform-aws-examples/tree/main/aws-cdn) for effectively utilizing this module.

### Inputs
---

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="enabled"></a> [enabled](#input\_enabled) | Flag to decide if the distribution is enabled to accept end user requests for content. | `bool` | `true` | no |  |
| <a name="ipv6_enabled"></a> [ipv6_enabled](#input\_ipv6\_enabled) | Flag to decide if ipv6 is enabled for the distribution. | `bool` | `false` | no |  |
| <a name="http_version"></a> [http_version](#input\_http\_version) | The maximum HTTP version to support on the distribution. | `string` | `"http2"` | no |  |
| <a name="price_class"></a> [price_class](#input\_price\_class) | The price class for this distribution. | `string` | `"PriceClass_All"` | no |  |
| <a name="aliases"></a> [aliases](#input\_aliases) | List of extra CNAMEs (alternate domain names) for this distribution. | `list(string)` | `[]` | no |  |
| <a name="default_root_object"></a> [default_root_object](#input\_default\_root\_object) | The object that CloudFront will return when an end user requests the root URL. | `string` | `"index.html"` | no |  |
| <a name="retain_on_delete"></a> [retain_on_delete](#input\_retain\_on\_delete) | Flag to decide if disable the distribution instead of deleting it when destroying the resource through Terraform. | `bool` | `false` | no |  |
| <a name="wait_for_deployment"></a> [wait_for_deployment](#input\_wait\_for\_deployment) | Flag to decide if the resource will wait for the distribution status to change from InProgress to Deployed." | `bool` | `true` | no |  |
| <a name="web_acl_id"></a> [web_acl_id](#input\_web\_acl\_id) | A unique identifier that specifies the AWS WAF web ACL, if any, to associate with the distribution. | `string` | `null` | no |  |
| <a name="comments"></a> [comments](#input\_comments) | Any comments to include about the distribution. | `string` | `null` | no |  |
| <a name="error_responses"></a> [error_responses](#input\_error\_responses) | List of Map with following key/pairs, for custom Error responses to be configured on CDN. | `list(map(string))` | `[]` | no |  |
| <a name="logging"></a> [logging](#input\_logging) | Configuration map (with following key-pair) of how logs are written to your distribution. | `map(string)` | `{}` | no |  |
| <a name="geo_restrictions"></a> [geo_restrictions](#input\_geo\_restrictions) | Configuration map for geo restrictrions | `any` | `{}` | no |  |
| <a name="tags"></a> [tags](#input\_tags) | A map of tags to assign to the distribution. | `map(string)` | `{}` | no |  |
| <a name="create_origin_access_identity"></a> [create_origin_access_identity](#input\_create\_origin\_access\_identity) | Flag to decide if create an Amazon Cloudfront Origin Access Identity. | `bool` | `false` | no |  |
| <a name="oai_comments"></a> [oai_comments](#input\_oai\_comments) | An optional comment for the origin access identity. | `string` | `null` | no |  |
| <a name="create_cloudfront_public_key"></a> [create_cloudfront_public_key](#input\_create\_cloudfront\_public\_key) | Flag to decide if create CloudFront public key. | `bool` | `false` | no |  |
| <a name="cloudfront_public_key"></a> [cloudfront_public_key](#input\_cloudfront\_public\_key) | Configuration map (with following key-pair) for Public Key. | `map(string)` | `{}` | no |  |
| <a name="enable_additional_moniroting"></a> [enable_additional_moniroting](#input\_enable\_additional\_moniroting) | Flag to decide if additional CloudWatch metrics are enabled for a CloudFront distribution. | `bool` | `false` | no |  |
| <a name="origins"></a> [origins](#origins) | List of Cloudfront Distribution's Origins Configiration Map. | `any` |  | yes |  |
| <a name="origin_groups"></a> [origin_groups](#origin\_groups) | List of Origin Groups Map. | `any` | `[]` | no |  |
| <a name="default_cache_behavior"></a> [default_cache_behavior](#cache\_behavior) | The default cache behaviour for the distribution. | `any` |  | yes |  |
| <a name="ordered_cache_behaviors"></a> [ordered_cache_behaviors](#cache\_behavior) | The List of configuration map of Cache behaviours for the distribution. | `any` | `[]` | no |  |
| <a name="origin_request_policy"></a> [origin_request_policy](#origin\_request\_policy) | List of Configuration Map for Origin Request Policies to be provisioned. | `any` | `[]` | no |  |
| <a name="cache_policy"></a> [cache_policy](#cache_policy) | List of Configuration Map for Cache Policies to be provisioned. | `any` | `[]` | no |  |
| <a name="cloudfront_default_certificate"></a> [cloudfront_default_certificate](#input\_cloudfront\_default\_certificate) | Flag to decide to use HTTPS to request your objects and you're using the CloudFront domain name for your distribution. | `bool` | `true` | no |  |
| <a name="acm_certificate_arn"></a> [acm_certificate_arn](#input\_acm\_certificate\_arn) | The ARN of the ACM certificate in `us-east-1` region to use with this distribution. | `string` | `null` | no |  |
| <a name="iam_certificate_id"></a> [iam_certificate_id](#input\_iam\_certificate\_id) | The IAM certificate identifier of the custom viewer certificate for this distribution if you are using a custom domain. | `string` | `null` | no |  |
| <a name="minimum_protocol_version"></a> [minimum_protocol_version](#input\_minimum\_protocol\_version) | The minimum version of the SSL protocol, CloudFront to use for HTTPS connections if `cloudfront_default_certificate` is set `false`. | `string` | `"TLSv1"` | no |  |
| <a name="ssl_support_method"></a> [ssl_support_method](#input\_ssl\_support\_method) | Specifies how you want CloudFront to serve HTTPS requests. | `string` | `null` | no |  |
| <a name="cloudfront_functions"></a> [cloudfront_functions](#cloudfront\_functions) | List of Configurations Map for the cloudfront functions to be provisioned | `map(string)` | `[]` | no |  |

### Nested Configuration Maps:  

#### origins

| Name | Description | Type | Default | Required | Example |
|:------|:------|:------|:------|:------:|:------|
| <a name="origin_id"></a> [origin_id](#input\_origin\_id) | A unique identifier for the origin. | `string` |  | yes |  |
| <a name="origin_path"></a> [origin_path](#input\_origin\_path) | Directory in origin from where CloudFront will request the content from. | `string` | `""` | no |  |
| <a name="domain_name"></a> [domain_name](#input\_domain\_name) | The DNS domain name of either the S3 bucket, or web site of your custom origin. | `string` |  | yes |  |
| <a name="connection_attempts"></a> [connection_attempts](#input\_connection\_attempts) | The number of times that CloudFront attempts to connect to the origin. | `number` | `3` | no |  |
| <a name="connection_timeout"></a> [connection_timeout](#input\_connection\_timeout) | The number of seconds that CloudFront waits when trying to establish a connection to the origin. | `number` | `10` | no |  |
| <a name="origin_access_control_id"></a> [origin_access_control_id](#input\_origin\_access\_control\_id) | The unique identifier of a CloudFront origin access control for this origin. | `string` | `null` | no |  |
| <a name="custom_headers"></a> [custom_headers](#input\_custom\_headers) | The Map of headers (Name/value pairs) to specify header data that will be sent to the origin. | `map(string)` | `{}` | no | <pre>{<br>  "X-alb-protection" = "testing"<br>} |
| <a name="origin_access_identity"></a> [origin_access_identity](#input\_origin\_access\_identity) | The CloudFront origin access identity to associate with the S3 origin. | `string` | `null` | no |  |
| <a name="custom_origin_config"></a> [custom_origin_config](#custom\_origin\_config) | Custom origin Configuration Map with following key-pairs: | `any` | `{}` | no | <pre>{<br>  http_port              = 80<br>  https_port             = 443<br>  origin_protocol_policy = "https-only"<br>  origin_ssl_protocols   = ["TLSv1.2"]<br>} |
| <a name="enable_origin_shield"></a> [enable_origin_shield](#input\_enable\_origin\_shield) | Flag to decide if origin shield is enabled, help to reduce the load on your origin. | `bool` | `false` | no |  |
| <a name="shield_region"></a> [shield_region](#input\_shield\_region) | The AWS Region (region-code) for Origin Shield. | `string` | `null` | no |  |

#### custom_origin_config

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="http_port"></a> [http_port](#input\_http\_port) | The HTTP port the custom origin listens on. | `number` |  | yes |
| <a name="https_port"></a> [https_port](#input\_https\_port) | The HTTPS port the custom origin listens on. | `number` |  | yes |
| <a name="origin_protocol_policy"></a> [origin_protocol_policy](#input\_origin\_protocol\_policy) | The origin protocol policy to apply to your origin. | `string` |  | yes |
| <a name="origin_ssl_protocols"></a> [origin_ssl_protocols](#input\_origin\_ssl\_protocols) | The list of SSL/TLS protocols that CloudFront will use when communicating with origin over HTTPS. | `list(string)` |  | yes |
| <a name="origin_keepalive_timeout"></a> [origin_keepalive_timeout](#input\_origin\_keepalive\_timeout) | The Custom KeepAlive timeout, in seconds. | `number` | `60` | no |
| <a name="origin_read_timeout"></a> [origin_read_timeout](#input\_origin\_read\_timeout) | The Custom Read timeout, in seconds. | `number` | `60` | no |

#### origin_groups

| Name | Description | Type | Required |
|:------|:------|:------|:------:|
| <a name="origin_group_id"></a> [origin_group_id](#input\_origin\_group\_id) | A unique identifier for the origin group. | `string` | yes |
| <a name="failover_status_codes"></a> [failover_status_codes](#input\_failover\_status\_codes) | A list of HTTP status codes for the origin group's failover criteria. | `list(number)` | yes |
| <a name="primary_member"></a> [primary_member](#input\_primary\_member) | The unique identifier of the primary member origin. | `string` | yes |
| <a name="secondary_member"></a> [secondary_member](#input\_secondary\_member) | The unique identifier of the secondary member origin. | `string` | yes |

#### cache_behavior

| Name | Description | Type | Default | Required | Example |
|:------|:------|:------|:------|:------:|:------|
| <a name="target_origin_id"></a> [target_origin_id](#input\_target\_origin\_id) | The value of ID for the origin that CloudFront will use to route requests to, when a request matches the path pattern either for a cache behavior or for the default cache behavior. | `string` |  | yes |  |
| <a name="viewer_protocol_policy"></a> [viewer_protocol_policy](#input\_viewer\_protocol\_policy) | The protocol that users can use to access the files in the origin. | `string` |  | yes |  |
| <a name="path_pattern"></a> [path_pattern](#input\_path\_pattern) | The pattern (for example, images/*.jpg) that specifies which requests this cache behavior to apply to. | `string` |  | no |  |
| <a name="allowed_methods"></a> [allowed_methods](#input\_allowed\_methods) | The list of HTTP methods that CloudFront processes and forwards to origin. | `list(string)` | `["GET", "HEAD"]` | no |  |
| <a name="cached_methods"></a> [cached_methods](#input\_cached\_methods) | The list of HTTP methods that CloudFront caches the response to requests for. | `list(string)` | `["GET", "HEAD"]` | no |  |
| <a name="compress"></a> [compress](#input\_compress) | Flag to decide if CloudFront compress the content automatically for web requests that include Accept-Encoding: gzip in the request header. | `bool` | `false` | no |  |
| <a name="default_ttl"></a> [default_ttl](#input\_default\_ttl) | The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header. | `number` | `86400` | no |  |
| <a name="min_ttl"></a> [min_ttl](#input\_min\_ttl) | The minimum amount of time, the objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. | `number` | `0` | no |  |
| <a name="max_ttl"></a> [max_ttl](#input\_max\_ttl) | The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated. | `number` | `31536000` | no |  |
| <a name="smooth_streaming"></a> [smooth_streaming](#input\_smooth\_streaming) | Indicates whether you want to distribute media files in Microsoft Smooth Streaming format. | `bool` | `true` | no |  |
| <a name="trusted_signers"></a> [trusted_signers](#input\_trusted\_signers) | List of AWS account IDs (or self) that you want to allow to create signed URLs for private content. | `list(string)` | `null` | no |  |
| <a name="trusted_key_groups"></a> [trusted_key_groups](#input\_trusted\_key\_groups) | List of nested attributes for active trusted key groups, if the distribution is set up to serve private content with signed URLs. | `any` | `null` | no |  |
| <a name="origin_request_policy_name"></a> [origin_request_policy_name](#input\_origin\_request\_policy\_name) | The name of the origin request policy that is attached to the behavior (as defined in `origin_request_policy`). | `string` | `null` | no |  |
| <a name="cache_policy_name"></a> [cache_policy_name](#input\_cache\_policy\_name) | The name of the cache policy that is attached to the cache behavior (as defined in `cache_policy`). | `string` | `null` | no |  |
| <a name="handle_forwarding"></a> [handle_forwarding](#input\_handle\_forwarding) | Flag to decide if thoe configuration should be done how the Cloudfront should handle the query strings, cookies and headers. | `bool` | `false` | no |  |
| <a name="cookie_behavior"></a> [cookie_behavior](#input\_cookie\_behavior) | Determines if CloudFront forward cookies to the origin. | `string` | `null` | no |  |
| <a name="cookies_items"></a> [cookies_items](#input\_cookies\_items) | Comma seperated List of Cookie names that CloudFront forward to your origin. | `string` | `null` | no |  |
| <a name="headers"></a> [headers](#input\_headers) | Comma seperated List of Header names that CloudFront forward to your origin. | `string` | `null` | no |  |
| <a name="query_strings"></a> [query_strings](#input\_query\_strings) | Flag to decide if CloudFront forward Query string to the origin. | `bool` | `null` | no |  |
| <a name="query_strings_cache_keys"></a> [query_strings_cache_keys](#input\_query\_strings\_cache\_keys) | Comma seperated List of Query strings which will be cahced. | `string` | `null` | no |  |
| <a name="edge_lambda_functions"></a> [edge_lambda_functions](#edge\_lambda\_functions) | Map of Lambda functions that Cloudfront can trigger on a predefined event. | `any` | `{}` | no |  |
| <a name="cloudfront_functions"></a> [cloudfront_functions](#input\_cloudfront\_functions) | Map of Cloudfront Functions:<br>&nbsp;&nbsp;&nbsp;<b>Map-Key:</b> Event Name (`viewer-request` or `viewer-response`)<br>&nbsp;&nbsp;&nbsp;<b>Map-Value:</b> Cloudfront function name as defined in `cloudfront_functions` | `map(string)` | `{}` | no |  |

#### origin_request_policy

| Name | Description | Type | Default | Required | Example |
|:------|:------|:------|:------|:------:|:------|
| <a name="name"></a> [name](#input\_name) | Unique name to identify the origin request policy. | `string` |  | yes |  |
| <a name="comments"></a> [comments](#input\_comments) | Comment to describe the origin request policy. | `string` | `Origin Request Policy - <Policy Name>` | no |  |
| <a name="cookie_behavior"></a> [cookie_behavior](#input\_cookie\_behavior) | Determines whether any cookies in viewer requests are included in the origin request key and automatically included in requests that CloudFront sends to the origin. | `string` | `"none"` | no |  |
| <a name="cookies_items"></a> [cookies_items](#input\_cookies\_items) | Comma seperated List of Cookie names. | `string` | `""` | no |  |
| <a name="header_behavior"></a> [header_behavior](#input\_header\_behavior) | Determines whether any HTTP headers are included in the origin request key and automatically included in requests that CloudFront sends to the origin.  | `string` | `"none"` | no |  |
| <a name="headers_items"></a> [headers_items](#input\_headers\_items) | Comma seperated List of header names. | `string` | `""` | no |  |
| <a name="query_string_behavior"></a> [query_string_behavior](#input\_query\_string\_behavior) | Determines whether any URL query strings in viewer requests are included in the origin request key and automatically included in requests that CloudFront sends to the origin. | `string` | `"none"` | no |  |
| <a name="query_strings_items"></a> [query_strings_items](#input\_query\_strings\_items) | Comma seperated List of query strings. | `string` | `""` | no |  |

#### cache_policy

| Name | Description | Type | Default | Required | Example |
|:------|:------|:------|:------|:------:|:------|
| <a name="name"></a> [name](#input\_name) | Unique name to identify the cache policy. | `string` |  | yes |  |
| <a name="comments"></a> [comments](#input\_comments) | Comment to describe the cache policy. | `string` | `Cache Policy - <Policy Name>` | no |  |
| <a name="default_ttl"></a> [default_ttl](#input\_default\_ttl) | The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront sends another request to the origin to determine whether the object has been updated. | `number` | `86400` | no |  |
| <a name="min_ttl"></a> [min_ttl](#input\_min\_ttl) | The minimum amount of time, the objects to stay in CloudFront caches before CloudFront sends another request to the origin to see whether the object has been updated. | `number` | `1` | no |  |
| <a name="max_ttl"></a> [max_ttl](#input\_max\_ttl) | The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront sends another request to the origin to determine whether the object has been updated. | `number` | `31536000` | no |  |
| <a name="cookie_behavior"></a> [cookie_behavior](#input\_cookie\_behavior) | Determines whether any cookies in viewer requests are included in the cache key and automatically included in requests that CloudFront sends to the origin. | `string` | `"none"` | no |  |
| <a name="cookies_items"></a> [cookies_items](#input\_cookies\_items) | Comma seperated List of Cookie names. | `string` | `""` | no |  |
| <a name="header_behavior"></a> [header_behavior](#input\_header\_behavior) | Determines whether any HTTP headers are included in the cache key and automatically included in requests that CloudFront sends to the origin.  | `string` | `"none"` | no |  |
| <a name="headers_items"></a> [headers_items](#input\_headers\_items) | Comma seperated List of header names. | `string` | `""` | no |  |
| <a name="query_string_behavior"></a> [query_string_behavior](#input\_query\_string\_behavior) | Determines whether any URL query strings in viewer requests are included in the cache key and automatically included in requests that CloudFront sends to the origin. | `string` | `"none"` | no |  |
| <a name="query_strings_items"></a> [query_strings_items](#input\_query\_strings\_items) | Comma seperated List of query strings. | `string` | `""` | no |  |
| <a name="enable_accept_encoding_brotli"></a> [enable_accept_encoding_brotli](#input\_enable\_accept\_encoding\_brotli) | A flag that can affect whether the Accept-Encoding HTTP header is included in the cache key and included in requests that CloudFront sends to the origin. | `bool` | `true` | no |  |
| <a name="enable_accept_encoding_gzip"></a> [enable_accept_encoding_gzip](#input\_enable\_accept\_encoding\_gzip) | A flag that can affect whether the Accept-Encoding HTTP header is included in the cache key and included in requests that CloudFront sends to the origin. | `bool` | `true` | no |  |

#### edge_lambda_functions

- Map Key: Event Name [`viewer-request`, `origin-request`, `viewer-response`, `origin-response`]
- Map Value: Nested Map as follows:

| Name | Description | Type | Default | Required | Example |
|:------|:------|:------|:------|:------:|:------|
| <a name="arn"></a> [arn](#input\_arn) | ARN of the Lambda function. | `string` |  | yes |  |
| <a name="include_body"></a> [include_body](#input\_include\_body) | When set to true it exposes the request body to the lambda function. | `bool` | `false` | no |  |

#### cloudfront_functions

| Name | Description | Type | Default | Required | Example |
|:------|:------|:------|:------|:------:|:------|
| <a name="name"></a> [name](#input\_name) | Unique name for your CloudFront Function. | `string` |  | yes |  |
| <a name="runtime"></a> [runtime](#input\_runtime) | Identifier of the function's runtime. | `string` |  | yes |  |
| <a name="comment"></a> [comment](#input\_comment) | Comment | `string` |  | no |  |
| <a name="publish"></a> [publish](#input\_publish) | Whether to publish creation/change as Live CloudFront Function Version. | `string` | `true` | no |  |
| <a name="code_file"></a> [code_file](#input\_code_file) | Source code File of the function (Path relative to root directory) | `string` |  | yes |  |

### Outputs

| Name | Type | Description |
|:------|:------|:------|
| <a name="id"></a> [id](#output\_id) | `string` | The identifier for the distribution. |
| <a name="arn"></a> [arn](#output\_arn) | `string` | The ARN (Amazon Resource Name) for the distribution. |
| <a name="status"></a> [status](#output\_status) | `string` | The current status of the distribution. |
| <a name="domain_name"></a> [domain_name](#output\_domain\_name) | `string` | The domain name corresponding to the distribution. |
| <a name="hosted_zone_id"></a> [hosted_zone_id](#output\_hosted\_zone\_id) | `string` | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. |
| <a name="oai_etag"></a> [oai_etag](#output\_oai\_etag) | `string` | Current version of the origin access identity's information. |
| <a name="oai_iam_arn"></a> [oai_iam_arn](#output\_oai\_iam\_arn) | `string` | Pre-generated ARN for use in S3 bucket policies. |
| <a name="oai_path"></a> [oai_path](#output\_oai_path) | `string` | A shortcut to the full path for the origin access identity to use in CloudFront. |
| <a name="public_key_id"></a> [public_key_id](#output\_public\_key\_id) | `string` | The identifier for the public key. |
| <a name="public_key_etag"></a> [public_key_etag](#output\_public\_key\_etag) | `string` | The current version of the public key. |
| <a name="monitoring_subscription_id"></a> [monitoring_subscription_id](#output\_monitoring\_subscription\_id) | `string` | The ID of the CloudFront monitoring subscription. |
| <a name="origin_request_policies"></a> [origin_request_policies](#output\_origin\_request\_policies) | `map(map(string))` | Map of The Origin Request Policies where each entry will be a key-pair of Origin Request Policy Name and nested map of attributes (id and etag) for the policy. |
| <a name="cache_policies"></a> [cache_policies](#output\_cache\_policies) | `map(map(string))` | Map of The Cache Policies where each entry will be a key-pair of Cache Policy Name and nested map of attributes (id and etag) for the policy. |

### Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-cdn/graphs/contributors).
