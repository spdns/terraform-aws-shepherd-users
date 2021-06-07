resource "aws_athena_workgroup" "shepherd" {
  count = length(var.subscriber_bucket)

  name        = format("%s-%s-workgroup-%s", var.project, var.environment, var.subscriber_bucket)
  description = format("%s %s workgroup for %s", var.project, var.environment, var.subscriber_bucket)
  state       = "ENABLED"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = format("s3://%s/%s/", module.athena_results.id, var.subscriber_bucket)

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }

  tags = local.project_tags
}