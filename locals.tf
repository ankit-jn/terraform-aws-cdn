locals {
    kinesis_resources = [ for log in var.realtime_log_configs: log.kinesis_stream_arn ]
}