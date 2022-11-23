resource aws_cloudfront_origin_request_policy "this" {
    for_each = { for policy in var.origin_request_policy: policy.name => policy }

    name = each.key
    comment = coalesce(each.value.comments, format("Origin Request Policy - %s", each.key))

    cookies_config {
        cookie_behavior = lookup(each.value, "cookie_behavior", "none") 
        cookies = contains(["all", "none"], lookup(each.value, "cookie_behavior", "none")) ? null : split(",", lookup(each.value, "cookies_items", ""))
    }
    
    headers_config {
        header_behavior = lookup(each.value, "header_behavior", "none") 
        cookies = (lookup(each.value, "header_behavior", "none") == "none") ? null : split(",", lookup(each.value, "headers_items", ""))
    }

    query_strings_config {
        header_behavior = lookup(each.value, "query_string_behavior", "none") 
        cookies = (lookup(each.value, "query_string_behavior", "none") == "none") ? null : split(",", lookup(each.value, "query_strings_items", ""))
    }
}

resource aws_cloudfront_cache_policy "this" {

    for_each = { for policy in var.cache_policy: policy.name => policy }

    name = each.key
    comment = coalesce(each.value.comments, format("Cache Policy - %s", each.key))

    default_ttl = try(each.value.default_ttl, 86400) ## default 86400 seconds (i.e.24 hours)
    min_ttl     = try(each.value.min_ttl, 1) ## default 0 second
    max_ttl     = try(each.value.max_ttl, 31536000) ## default 31536000 seconds (i.e.365 days)

    parameters_in_cache_key_and_forwarded_to_origin {
        cookies_config {
            cookie_behavior = try(each.value.cookie_behavior, "none") 
            cookies = contains(["all", "none"], try(each.value.cookie_behavior, "none")) ? null : split(",", try(each.value.cookies_items, ""))
        }
        
        headers_config {
            header_behavior = try(each.value.header_behavior, "none") 
            cookies = (try(each.value.header_behavior.none) == "none") ? null : split(",", try(each.value.headers_items, ""))
        }

        query_strings_config {
            header_behavior = try(each.value.query_string_behavior, "none") 
            cookies = (try(each.value.query_string_behavior, "none") == "none") ? null : split(",", try(each.value.query_strings_items, ""))
        }
        enable_accept_encoding_brotli = try(each.value.enable_accept_encoding_brotli, true)
        enable_accept_encoding_gzip   = try(each.value.enable_accept_encoding_gzip, true)
    }
}