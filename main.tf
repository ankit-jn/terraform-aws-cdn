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
        target_origin_id = var.default_cache_behavior.target_origin_id

        viewer_protocol_policy = var.default_cache_behavior.viewer_protocol_policy
        path_pattern = try(var.default_cache_behavior.path_pattern, "*")
        
        allowed_methods = try(var.default_cache_behavior.allowed_methods, ["GET", "HEAD"])
        cached_methods = try(var.default_cache_behavior.cached_methods, ["GET", "HEAD"])
        
        compress = try(var.default_cache_behavior.compress, false)

        default_ttl = try(var.default_cache_behavior.default_ttl, 86400) ## default 86400 seconds (i.e.24 hours)
        min_ttl     = try(var.default_cache_behavior.min_ttl, 0) ## default 0 second
        max_ttl     = try(var.default_cache_behavior.max_ttl, 31536000) ## default 31536000 seconds (i.e.365 days)
        
        smooth_streaming = try(var.default_cache_behavior.smooth_streaming, true)
        realtime_log_config_arn =  try(var.default_cache_behavior.realtime_log_config_arn, "") != "" ? (
                                            var.default_cache_behavior.realtime_log_config_arn) : (
                                                try(var.default_cache_behavior.realtime_log_config_name, "") == "" ? null : (
                                                        realtime_log_config.this[var.default_cache_behavior.realtime_log_config_name].arn))
        field_level_encryption_id = try(var.default_cache_behavior.encryption_profile_arn, "") != "" ? (
                                            var.default_cache_behavior.encryption_profile_arn) : (
                                                try(var.default_cache_behavior.encryption_profile_name, "") == "" ? null : (
                                                        aws_cloudfront_field_level_encryption_profile.this[var.default_cache_behavior.encryption_profile_name].id))
        
        trusted_signers     = try(var.default_cache_behavior.trusted_signers, null)
        trusted_key_groups  = (can(var.default_cache_behavior.trusted_key_group_names) 
                                    || can(var.default_cache_behavior.trusted_key_group_arns)) ? (
                                        concat(try(var.default_cache_behavior.trusted_key_group_arns, []), 
                                                [ for key_group_name in split(",", try(var.default_cache_behavior.trusted_key_group_names, "")): 
                                                                    aws_cloudfront_public_key.this[key_group_name].id])) : null
                
        cache_policy_id = try(var.default_cache_behavior.cache_policy_arn, "") != "" ? (
                                    var.default_cache_behavior.cache_policy_arn) : (
                                        try(var.default_cache_behavior.cache_policy_name, "") == "" ? null : (
                                            aws_cloudfront_cache_policy.this[var.default_cache_behavior.cache_policy_name].id))

        origin_request_policy_id = try(var.default_cache_behavior.origin_request_policy_arn, "") != "" ? (
                                        var.default_cache_behavior.origin_request_policy_arn) : (
                                            try(var.default_cache_behavior.origin_request_policy_name, "") == "" ? null : (
                                                aws_cloudfront_origin_request_policy.this[var.default_cache_behavior.origin_request_policy_name].id))

        response_headers_policy_id = try(var.default_cache_behavior.response_headers_policy_arn, "") != "" ? (
                                    var.default_cache_behavior.response_headers_policy_arn) : (
                                            try(var.default_cache_behavior.response_headers_policy_name, "") == "" ? null : (
                                                aws_cloudfront_response_headers_policy.this[var.default_cache_behavior.response_headers_policy_name].id))

        dynamic "forwarded_values" {
            for_each = try(cache_behavior.value.handle_forwarding, false) ? [1] : []
            
            content {
                cookies {
                    forward = try(cache_behavior.value.cookie_behavior, "none")
                    whitelisted_names = contains(["all", "none"], lookup(cache_behavior.value, "cookie_behavior", "none")) ? null : split(",", lookup(each.value, "cookies_items", ""))
                }
                headers = try(cache_behavior.value.headers, null)
                query_string = try(cache_behavior.value.query_strings, false)
                query_string_cache_keys = try(cache_behavior.value.query_strings, false) ? split(",", lookup(each.value, "query_strings_cache_keys", "")) : null
            }
        }

        dynamic "lambda_function_association" {
            for_each = try(cache_behavior.value.edge_lambda_functions, {})

            content {
                event_type = lambda_function_association.key
                lambda_arn = lambda_function_association.value.arn
                include_body = try(lambda_function_association.value.include_body, false)
            }
        }

        dynamic "function_association" {
            for_each = try(cache_behavior.value.cloudfront_functions, {})

            content {
                event_type = function_association.key
                function_arn = cloudfront_functions.this[function_association.value].arn
            }    
        }
    }

    dynamic "ordered_cache_behavior" {
        for_each = var.default_cache_behaviors
        iterator = cache_behavior

        content {
            target_origin_id = cache_behavior.value.target_origin_id

            viewer_protocol_policy = cache_behavior.value.viewer_protocol_policy
            path_pattern = try(cache_behavior.value.path_pattern, "*")
            
            allowed_methods = try(cache_behavior.value.allowed_methods, ["GET", "HEAD"])
            cached_methods = try(cache_behavior.value.cached_methods, ["GET", "HEAD"])
            
            compress = try(cache_behavior.value.compress, false)

            default_ttl = try(cache_behavior.value.default_ttl, 86400) ## default 86400 seconds (i.e.24 hours)
            min_ttl     = try(cache_behavior.value.min_ttl, 0) ## default 0 second
            max_ttl     = try(cache_behavior.value.max_ttl, 31536000) ## default 31536000 seconds (i.e.365 days)
            
            smooth_streaming = try(cache_behavior.value.smooth_streaming, true)

            realtime_log_config_arn =  try(cache_behavior.value.realtime_log_config_arn, "") != "" ? (
                                            cache_behavior.value.realtime_log_config_arn) : (
                                                try(cache_behavior.value.realtime_log_config_name, "") == "" ? null : (
                                                        realtime_log_config.this[cache_behavior.value.realtime_log_config_name].arn))
            
            field_level_encryption_id = try(cache_behavior.value.encryption_profile_arn, "") != "" ? (
                                            cache_behavior.value.encryption_profile_arn) : (
                                                try(cache_behavior.value.encryption_profile_name, "") == "" ? null : (
                                                        aws_cloudfront_field_level_encryption_profile.this[cache_behavior.value.encryption_profile_name].id))
            
            trusted_signers     = try(cache_behavior.value.trusted_signers, null)
            trusted_key_groups  = (can(cache_behavior.value.trusted_key_group_names) 
                                        || can(cache_behavior.value.trusted_key_group_arns)) ? (
                                            concat(try(cache_behavior.value.trusted_key_group_arns, []), 
                                                    [ for key_group_name in split(",", try(cache_behavior.value.trusted_key_group_names, "")): 
                                                                        aws_cloudfront_public_key.this[key_group_name].id])) : null

            cache_policy_id = try(cache_behavior.value.cache_policy_arn, "") != "" ? (
                                        cache_behavior.value.cache_policy_arn) : (
                                                try(cache_behavior.value.cache_policy_name, "") == "" ? null : (
                                                    aws_cloudfront_cache_policy.this[cache_behavior.value.cache_policy_name].id))

            origin_request_policy_id = try(cache_behavior.value.origin_request_policy_arn, "") != "" ? (
                                        cache_behavior.value.origin_request_policy_arn) : (
                                                try(cache_behavior.value.origin_request_policy_name, "") == "" ? null : (
                                                    aws_cloudfront_origin_request_policy.this[cache_behavior.value.origin_request_policy_name].id))

            response_headers_policy_id = try(cache_behavior.value.response_headers_policy_arn, "") != "" ? (
                                        cache_behavior.value.response_headers_policy_arn) : (
                                                try(cache_behavior.value.response_headers_policy_name, "") == "" ? null : (
                                                    aws_cloudfront_response_headers_policy.this[cache_behavior.value.response_headers_policy_name].id))

            dynamic "forwarded_values" {
                for_each = try(cache_behavior.value.handle_forwarding, false) ? [1] : []
                
                content {
                    cookies {
                        forward = try(cache_behavior.value.cookie_behavior, "none")
                        whitelisted_names = contains(["all", "none"], lookup(cache_behavior.value, "cookie_behavior", "none")) ? null : split(",", lookup(each.value, "cookies_items", ""))
                    }
                    headers = try(cache_behavior.value.headers, null)
                    query_string = try(cache_behavior.value.query_strings, false)
                    query_string_cache_keys = try(cache_behavior.value.query_strings, false) ? split(",", lookup(each.value, "query_strings_cache_keys", "")) : null
                }
            }
            
            dynamic "lambda_function_association" {
                for_each = try(cache_behavior.value.edge_lambda_functions, {})

                content {
                    event_type = lambda_function_association.key
                    lambda_arn = lambda_function_association.value.arn
                    include_body = try(lambda_function_association.value.include_body, false)
                }
            }            
            
            dynamic "function_association" {
                for_each = try(cache_behavior.value.cloudfront_functions, {})

                content {
                    event_type = function_association.key
                    function_arn = cloudfront_functions.this[function_association.value].arn
                }    
            }
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = var.cloudfront_default_certificate
        acm_certificate_arn = var.cloudfront_default_certificate ? null : var.acm_certificate_arn
        iam_certificate_id = var.cloudfront_default_certificate ? null : var.iam_certificate_id
        minimum_protocol_version = var.minimum_protocol_version
        ssl_support_method = try(var.ssl_support_method, null)
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

    depends_on = [
      aws_cloudfront_function.this,
      aws_cloudfront_origin_request_policy.this,
      aws_cloudfront_cache_policy.this
    ]
}