resource aws_cloudfront_distribution "this" {
    enabled = var.enabled
    
    origin_group {
        ## TO DO
    }
    
    origin {
        ## TO DO
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