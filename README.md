## ARJ-Stack: AWS Cloudfront Distribution Network (CDN) Terraform module

A Terraform module for configuring Content Delivery Network in AWS

### Resources
This module features the following components to be provisioned:

- Cloudfront Distribution [[aws_cloudfront_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution)]
- Origin Access Identity [[aws_cloudfront_origin_access_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity)]
- Cloudfront Public Key [[aws_cloudfront_public_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_public_key)]
- Additional Cloudwatch Monitoring for CDN [[aws_cloudfront_monitoring_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_monitoring_subscription)]

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
| <a name="http_version"></a> [http_version](#input\_http\_version) | The maximum HTTP version to support on the distribution. | `string` | `http2` | no |  |
| <a name="price_class"></a> [price_class](#input\_price\_class) | The price class for this distribution. | `string` | `PriceClass_All` | no |  |
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

### Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-cdn/graphs/contributors).
