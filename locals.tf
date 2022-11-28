locals {
    create_realtime_logging_role = var.create_realtime_logging_role && (length(var.realtime_log_configs) > 0)
    kinesis_resources = join(",", [ for log in var.realtime_log_configs: log.kinesis_stream_arn ])
}