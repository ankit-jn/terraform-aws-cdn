resource aws_cloudfront_distribution "this" {
    enabled = var.enabled
    
    dynamic "origin" {
        for_each = var.origins 

        content {
            origin_id   = origin.value.origin_id
            origin_path = try(origin.value.origin_path, "")
            
            domain_name = origin.value.domain_name
            
            connection_attempts = try(origin.value.connection_attempts, 3)
            connection_timeout  = try(origin.value.connection_timeout, 10)

            origin_access_control_id = try(origin.value.origin_access_control_id, null)

            dynamic "s3_origin_config" {
                for_each = (var.create_origin_access_identity 
                                || length(try(origin.value.origin_access_identity, "")) > 0) ? [1] : []

                content {
                    origin_access_identity = !var.create_origin_access_identity ? (
                                                    origin.value.origin_access_identity) : (
                                                                aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path)
                }
            }
        
            dynamic "custom_origin_config" {
                for_each = [ try(origin.value.custom_origin_config, {}) ]

                content {
                    http_port                = custom_origin_config.value.http_port
                    https_port               = custom_origin_config.value.https_port
                    origin_protocol_policy   = custom_origin_config.value.origin_protocol_policy
                    origin_ssl_protocols     = custom_origin_config.value.origin_ssl_protocols
                    origin_keepalive_timeout = try(custom_origin_config.value.origin_keepalive_timeout, 60)
                    origin_read_timeout      = try(custom_origin_config.value.origin_read_timeout, 60)
                }
            }

            dynamic "custom_header" {
                for_each = try(each.value.custom_headers, {})

                content {
                    name = custom_header.key
                    value = custom_header.value
                }
            }

            origin_shield {
                for_each = each.value.enable_origin_shield ? [1] : []

                content {
                    enabled              = true
                    origin_shield_region = each.value.shield_region
                }
            }
        }
    }

    dynamic "origin_group" {
        for_each = var.origin_groups

        content {
            origin_id = origin_group.value.origin_group_id
            failover_criteria {
                status_codes = origin_group.value.failover_status_codes
            }
            member {
                origin_id = origin_group.value.primary_member
            }
            member {
                origin_id = origin_group.value.secondary_member
            }            
        }
    }


    default_cache_behavior {
        ## TO DO
    }

    ordered_cache_behavior {
        ## TO DO
    }

    viewer_certificate {
        ## TO DO
    }
    
    is_ipv6_enabled = var.ipv6_enabled
    http_version = var.http_version
    price_class = var.price_class

    aliases = var.aliases
    default_root_object = var.default_root_object
    
    retain_on_delete = var.retain_on_delete
    wait_for_deployment = var.wait_for_deployment

    web_acl_id = var.web_acl_id

    comment = var.comments

    dynamic "custom_error_response" {
        for_each = var.error_responses

        content {
            error_code = custom_error_response.value.error_code
            response_code = try(custom_error_response.value.response_code, null)
            error_caching_min_ttl = try(custom_error_response.value.error_caching_min_ttl, null)
            response_page_path = try(custom_error_response.value.response_page_path, null)
        }
    }

    dynamic "logging_config" {
        for_each = try(length(keys(var.logging)), 0) > 0 ? [1] : 0

        content {
            bucket = var.logging.bucket
            include_cookies = try(var.logging.include_cookies, false)
            prefix = try(var.logging.prefix, null)
        }
    }

    restrictions {
        geo_restrictions {
            restriction_type = try(geo_restrictions.value.restriction_type, "none")
            locations = try(geo_restrictions.value.locations, [])
        }
    }

    tags = var.tags
}

resource aws_cloudfront_origin_access_identity "this" {
    count = var.create_origin_access_identity ? 1 : 0
    
    comment = var.oai_comments
}

resource aws_cloudfront_public_key "this" {
    count = var.create_cloudfront_public_key ? 1 : 0

    comment     = coalesce(var.cloudfront_public_key.comments, var.cloudfront_public_key.name)
    encoded_key = file("${path.root}/${var.cloudfront_public_key.file}")
    name        = var.cloudfront_public_key.name
}

resource aws_cloudfront_monitoring_subscription "this" {
  
    distribution_id = aws_cloudfront_distribution.this.id

    monitoring_subscription {
        realtime_metrics_subscription_config {
            realtime_metrics_subscription_status = var.enable_additional_moniroting ? "Enabled" : "Disabled"
        }
    }
}