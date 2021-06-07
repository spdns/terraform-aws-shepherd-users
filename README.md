
# App Shepherd Global

This module is used to configure AWS resources to work with the Shepherd project.

## ETL Pipeline

![etl-pipeline](./images/etlpipeline.png)

## Usage

Creates metric alarms for use with a Lambda Function

* Success rate

```hcl
module "shepherd" {
  source = "dod-iac/shepherd/aws"

  subscriber_buckets = [
    "bucket1",
    "bucket2",
  ]

  shepherd_users = [
    "iam_user1",
    "iam_user2",
  ]

  tags = {
    Project     = var.project
    Application = var.application
    Environment = var.environment
    Automation  = "Terraform"
  }
}
```

## Terraform Version

Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.

Terraform 0.11 and 0.12 are not supported.

## License

This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.

## Manual Operations Log

### Athena Workgroups

For the Athena Workgroups it is required that the options "Queries with requester pays buckets" is set to "Enabled". Ensure that both the Athena `primary` workgroup and the Shepherd workgroups have this enabled. This will have to be done manually for any new workgroups added.

### Create the Glue Tables

Each database needs a table with the data. There is a saved query in each workgroup for creating the table. After switching workgroups, and while checking the correct DB is selected, run the `create-table` query. This needs to be done for each database, remembering to switch workgroups each time. Confirm that the tables exist by looking in AWS Glue or in AWS Athena by selecting the appropriate database.

### AWS IAM Roles

There are two roles that must be passed to the vendor and appear as outputs:

* shepherd\_glue\_role\_arn: The role used by AWS Glue to do ETL on the data
* shepherd\_users\_role\_arn: The role used by IAM users to work with the resources configured by this module

### AWS SSM Parameters

Some data needs to be placed in AWS SSM Parameter store. They are:

* `salt`: A random 32 character string used as a salt for hashing algorithms

To write a variable use the [chamber](https://github.com/segmentio/chamber) tool:

```sh
SALT=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 32 | head -n 1)
chamber write shepherd-global salt "${SALT}"
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| template | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| athena_results | trussworks/s3-private-bucket/aws | ~> 3.2.1 |
| aws_logs | trussworks/logs/aws | ~> 10.0.0 |
| glue_tmp_bucket | trussworks/s3-private-bucket/aws | ~> 3.2.1 |

## Resources

| Name |
|------|
| [aws_athena_named_query](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_named_query) |
| [aws_athena_workgroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_workgroup) |
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) |
| [aws_glue_catalog_database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database) |
| [aws_glue_job](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_job) |
| [aws_glue_security_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_security_configuration) |
| [aws_glue_trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_trigger) |
| [aws_iam_account_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_account_alias) |
| [aws_iam_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) |
| [aws_iam_group_membership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership) |
| [aws_iam_group_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) |
| [aws_iam_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_user) |
| [aws_partition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) |
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) |
| [aws_s3_bucket_object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) |
| [aws_ssm_parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) |
| [template_file](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application | n/a | `string` | `"shepherd"` | no |
| csv\_bucket\_allowed\_ip\_blocks | List of CIDR blocks allowed to access the CSV bucket | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| csv\_bucket\_name | The name of the S3 bucket hosting the publicly accessible CSV files. The name must be a valid DNS name. Best practice is to use a unique hash in the name, ie UNIQUEHASH.example.com | `string` | `""` | no |
| csv\_jobs | Details for each CSV job. See comments in code for details | `list(map(string))` | `[]` | no |
| environment | n/a | `string` | `"global"` | no |
| project | n/a | `string` | `"shepherd"` | no |
| region | n/a | `string` | `"us-gov-west-1"` | no |
| shepherd\_engineers | The set of IAM user names to add to the 'shepherd\_engineers' group | `list(string)` | `[]` | no |
| shepherd\_users | The set of IAM user names to add to the 'shepherd\_users' group | `list(string)` | `[]` | no |
| subscriber\_buckets | The set of AWS S3 buckets to subscribe too | `list(string)` | `[]` | no |
| tags | The tags for the project | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| csv\_results\_bucket | The CSV results bucket name |
| csv\_website\_domain | The CSV domain of the website endpoint, if the bucket is configured with a website. This is used to create Route 53 alias records. |
| csv\_website\_endpoint | The CSV website endpoint, if the bucket is configured with a website. |
| shepherd\_glue\_role\_arn | shepherd glue role arn |
| shepherd\_users\_role\_arn | shepherd-users role arn |
