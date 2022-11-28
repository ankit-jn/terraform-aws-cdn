resource aws_cloudfront_function "this" {
    for_each = { for function in var.cloudfront_functions: function.name => function }

    name    = each.key
    runtime = each.value.runtime
    comment = try(each.value.comment, each.key)
    publish = try(each.value.publish, true)
    
    code = file("${path.root}/${each.value.code_file}")
}