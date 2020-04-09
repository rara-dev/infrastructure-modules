provider "aws" {
  # The AWS region in which all resources will be created
  region = var.aws_region

  # Require a 2.x version of the AWS provider
  version = "~> 2.6"

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = [var.aws_account_id]
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt or via a backend.hcl file. See
  # https://www.terraform.io/docs/backends/config.html#partial-configuration
  backend "s3" {}

  # Only allow this Terraform version. Note that if you upgrade to a newer version, Terraform won't allow you to use an
  # older version, so when you upgrade, you should upgrade everyone on your team and your CI servers all at once.
  required_version = "= 0.12.24"
}

module "root_baseline" {
  source = "git::git@github.com:gruntwork-io/module-security.git//modules/account-baseline-root?ref=v0.28.4"

  aws_account_id = var.aws_account_id
  aws_region     = var.aws_region
  name_prefix    = var.name_prefix

  // If you're running the example against an account that doesn't have AWS Organization created, change the following value to true
  create_organization = var.create_organization

  child_accounts = var.child_accounts
}

