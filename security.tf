resource aws_cloudfront_origin_access_identity "this" {
    count = var.create_origin_access_identity ? 1 : 0
    
    comment = var.oai_comments
}

resource aws_cloudfront_public_key "this" {
    for_each = { for key in var.public_keys: key.name => key }

    name        = each.key
    comment     = coalesce(each.value.comments, each.key)
    encoded_key = file("${path.root}/${each.value.key_file}")   
}

resource aws_cloudfront_key_group "this" {
    for_each = { for group in var.key_groups: group.name => group }

    name        = each.key
    comment     = coalesce(each.value.comments, each.key)
    items       = [for key_name in split(",", each.value.keys): aws_cloudfront_public_key.this[key_name].id]
}

resource aws_cloudfront_field_level_encryption_profile "this" {
    for_each = { for profile in var.encryption_profiles: profile.name => profile }

    name = each.key
    comment = coalesce(each.value.comments, format("Encryption Profile - %s", each.key))

    encryption_entities {
        items {
            public_key_id = aws_cloudfront_public_key.this[each.value.key_name].id
            provider_id   = each.value.provider_id

            field_patterns {
              items = each.value.field_patterns
            }
        }
    }
}