resource aws_cloudfront_cache_policy "this" {

    for_each = { for policy in var.cache_policies: policy.name => policy }

    name = each.key
    comment = coalesce(try(each.value.comments, ""), format("Cache Policy - %s", each.key))

    default_ttl = try(each.value.default_ttl, 86400) ## default 86400 seconds (i.e.24 hours)
    min_ttl     = try(each.value.min_ttl, 1) ## default 0 second
    max_ttl     = try(each.value.max_ttl, 31536000) ## default 31536000 seconds (i.e.365 days)

    parameters_in_cache_key_and_forwarded_to_origin {
        cookies_config {
            cookie_behavior = try(each.value.cookie_behavior, "none") 
            dynamic "cookies" {
                for_each = contains(["all", "none"], try(each.value.cookie_behavior, "none")) ? [] : [1]
                content {
                    items = split(",", try(each.value.cookies_items, ""))
                }
            }
        }
        
        headers_config {
            header_behavior = try(each.value.header_behavior, "none") 
            dynamic "headers" {
                for_each = try(each.value.header_behavior, "none") == "none" ? [] : [1]
                
                content {
                    items = split(",", try(each.value.headers_items, ""))
                }                
            }
        }

        query_strings_config {
            query_string_behavior = try(each.value.query_string_behavior, "none") 
            dynamic "query_strings" {
                for_each = contains(["all", "none"], try(each.value.query_string_behavior, "none")) ? [] : [1]
                
                content {
                    items = split(",", try(each.value.query_strings_items, ""))
                }
            }
        }
        enable_accept_encoding_brotli = try(each.value.enable_accept_encoding_brotli, true)
        enable_accept_encoding_gzip   = try(each.value.enable_accept_encoding_gzip, true)
    }
}

resource aws_cloudfront_origin_request_policy "this" {
    for_each = { for policy in var.origin_request_policies: policy.name => policy }

    name = each.key
    comment = coalesce(try(each.value.comments, ""), format("Origin Request Policy - %s", each.key))

    cookies_config {
        cookie_behavior = try(each.value.cookie_behavior, "none") 
        dynamic "cookies" {
            for_each = contains(["all", "none"], try(each.value.cookie_behavior, "none")) ? [] : [1]
            
            content {
                items =  split(",", try(each.value.cookies_items, ""))
            }
        }
    }
    
    headers_config {
        header_behavior = try(each.value.header_behavior, "none") 
        dynamic "headers" {
            for_each = try(each.value.header_behavior, "none") == "none" ? [] : [1]

            content {
                items = split(",", try(each.value.headers_items, ""))
            }
        }
    }

    query_strings_config {
        query_string_behavior = try(each.value.query_string_behavior, "none") 
        dynamic "query_strings" {
            for_each = contains(["all", "none"], try(each.value.query_string_behavior, "none")) ? [] : [1]
            
            content {
                items = split(",", try(each.value.query_strings_items, ""))
            }
        }
    }
}

resource aws_cloudfront_response_headers_policy "this" {

    for_each = { for policy in var.response_headers_policies: policy.name => policy }

    name = each.key
    comment = coalesce(try(each.value.comments, ""), format("Response Headers Policy - %s", each.key))

    dynamic "cors_config" {
        for_each = try(each.value.configure_cors, false) ? [1] : []

        content {
            access_control_allow_credentials = try(each.value.access_control_allow_credentials, false)
            origin_override = try(each.value.origin_override, true)
            access_control_max_age_sec  = try(each.value.max_age, 600)
            
            access_control_allow_origins {
                items = length(try(each.value.allowed_origins, [])) > 0 ? each.value.allowed_origins : (
                                        try(each.value.access_control_allow_credentials, false) ? [] : ["*"])
            }

            access_control_allow_headers {
                items = length(try(each.value.allowed_headers, [])) > 0 ? each.value.allowed_headers : (
                                        try(each.value.access_control_allow_credentials, false) ? [] : ["*"])
            }

            access_control_allow_methods {
                items = length(try(each.value.allowed_methods, [])) > 0 ? each.value.allowed_methods : (
                                        try(each.value.access_control_allow_credentials, false) ? [] : ["*"])
            }

            dynamic "access_control_expose_headers" {
                for_each = length(try(each.value.exposed_headers, [])) > 0 ? [1] : []

                content {
                    items =  each.value.exposed_headers
                }
            }
        }
    }

    dynamic "security_headers_config" {
        for_each = (try(each.value.configure_strict_transport_security, false)
                        || try(each.value.configure_content_type_options, false)
                        || try(each.value.configure_frame_options, false)
                        || try(each.value.configure_xss_protection, false)
                        || try(each.value.configure_referrer_policy, false)
                        || try(each.value.configure_content_security_policy, false)) ? [1] : []
        content {
            dynamic "strict_transport_security" {
                for_each = try(each.value.configure_strict_transport_security, false) ? [1] : []

                content {
                    access_control_max_age_sec = try(each.value.strict_transport_security.max_age_sec, 31536000)
                    include_subdomains = try(each.value.strict_transport_security.origin_override, false)
                    override = try(each.value.strict_transport_security.origin_override, true)
                    preload = try(each.value.strict_transport_security.preload, false)
                }
            }

            dynamic "content_type_options" {
                for_each = try(each.value.configure_content_type_options, false) ? [1] : []

                content {
                    override = try(each.value.content_type_options_override_origin, true)
                }
            }

            dynamic "frame_options" {
                for_each = try(each.value.configure_frame_options, false) ? [1] : []

                content {
                    frame_option = try(each.value.frame_option, "DENY")
                    override = try(each.value.frame_options_override_origin, true)
                }
            }

            dynamic "xss_protection" {
                for_each = try(each.value.configure_xss_protection, false) ? [1] : []

                content {
                    mode_block = try(each.value.xss_protection.mode_block, false)
                    override = try(each.value.xss_protection.override_origin, true)
                    protection = try(each.value.xss_protection.protection, true)
                    report_uri = try(each.value.xss_protection.mode_block, false) ? null : try(each.value.xss_protection.report_uri, null)
                }
            }

            dynamic "referrer_policy" {
                for_each = try(each.value.configure_referrer_policy, false) ? [1] : []

                content {
                    referrer_policy = try(each.value.referrer_policy.policy, "no-referrer")
                    override = try(each.value.referrer_policy.override_origin, true)
                }
            }

            dynamic "content_security_policy" {
                for_each = try(each.value.configure_content_security_policy, false) ? [1] : []

                content {
                    content_security_policy = each.value.content_security_policy.policy
                    override = try(each.value.content_security_policy.override_origin, true)
                }
            }
        }
    }
    
    dynamic "custom_headers_config" {
        for_each = length(try(each.value.custom_headers, [])) > 0 ? [1] : []

        content {
            dynamic "items" {
                for_each = each.value.custom_headers

                content {
                    header   = items.value.header
                    value    = items.value.value
                    override = try(items.value.override_origin, true)
                }
            }
        }
    }

    dynamic "server_timing_headers_config" {
        for_each = try(each.value.enable_server_timing_header, false) ? [1] : []

        content {
            enabled       = true
            sampling_rate = try(each.value.sampling_rate, 0)
        }
    }
}