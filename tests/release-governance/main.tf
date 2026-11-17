terraform {
  required_version = ">= 1.15.7"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# Fixture inputs are consumed when release policy source is copied into the test root.
# tflint-ignore: terraform_unused_declarations
variable "github_organization" {
  type    = string
  default = "release-contract-fixture"
}

# Exercise the production Pages reference against the real repository module.
module "repos" {
  source      = "../../modules/github_repo"
  for_each    = toset(["docs_portal"])
  name        = "docs-portal"
  description = "Documentation portal fixture"
}
