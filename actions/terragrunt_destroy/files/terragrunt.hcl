locals {
   version =          yamldecode(file(find_in_parent_folders("version.yaml"))).version
   account_id =       get_aws_account_id()
   region =           yamldecode(file(find_in_parent_folders("region.yaml"))).region
   system_name =      yamldecode(file(find_in_parent_folders("system.yaml"))).system_name
   sub_system_name =  yamldecode(file(find_in_parent_folders("sub_system.yaml"))).sub_system_name
   stack_name =       yamldecode(file(find_in_parent_folders("stack.yaml"))).stack_name
   environment =      yamldecode(file(find_in_parent_folders("environment.yaml"))).environment
 }

generate "context" {
  path = "context.yaml"
  if_exists = "overwrite"
  contents = <<EOF
version:          ${local.version}
account_id:       ${local.account_id}
region:           ${local.region}
system_name:      ${local.system_name}
sub_system_name:  ${local.sub_system_name}
stack_name:       ${local.stack_name}
environment:      ${local.environment}
EOF
 }


generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "aws" {
    region = "${local.region}"
    default_tags {
      tags = {
        system_name = "${local.system_name}"
        sub_system_name = "${local.sub_system_name}"
        stack_name = "${local.stack_name}"
        environment = "${local.environment}"
        version = "${local.version}"
        iac = "terraform"
      }
    }
  }
  EOF
}

remote_state {
    backend = "s3"
    config = {
        encrypt                 = true
        bucket                  = "${local.account_id}-cicd-gha-runner-cloud-bootstrap-${local.environment}-tf-state"
        key                     = "${local.system_name}-${local.sub_system_name}-${local.stack_name}-${local.environment}"
        region                  = local.region
        dynamodb_table          = "${local.system_name}-${local.sub_system_name}-${local.stack_name}-${local.environment}"
        disable_bucket_update   = true
    }
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}

terraform {
  source = "./"
}