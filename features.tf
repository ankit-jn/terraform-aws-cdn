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