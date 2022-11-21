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
| <a name="public_key_id"></a> [public_key_id](#output\_public\_key\_id) | `string` | The identifier for the public key. |
| <a name="public_key_etag"></a> [public_key_etag](#output\_public\_key\_etag) | `string` | The current version of the public key. |
| <a name="monitoring_subscription_id"></a> [monitoring_subscription_id](#output\_monitoring\_subscription\_id) | `string` | The ID of the CloudFront monitoring subscription. |

### Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-cdn/graphs/contributors).