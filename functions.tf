resource aws_cloudfront_function "this" {
    for_each = { for function in var.cloudfront_functions: funcation.name => function }

    name    = each.key
    runtime = each.value.runtime
    comment = try(each.value.comment, each.key)
    publish = try(each.value.publish, true)
    
    code_file = file("${path.root}/${code_file}")
}