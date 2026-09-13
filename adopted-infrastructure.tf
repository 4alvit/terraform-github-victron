# Existing manually created infrastructure, adopted without changing its policy.
# Keep disabled reviews and archived repository settings as observed.

resource "github_repository" "venus_os_governance" {
  name        = "venus-os-governance"
  description = "Policy engine with approval gates for Venus OS — SOC limits, charge/discharge rules, inverter control policies with audit logging via dbus-event-log [ARCHIVED 2026-08 — superseded by inverter-control built-in safety]"
  visibility  = "public"
  archived    = true
  # Provider skips refreshing these fields for archived repositories; preserve
  # the values verified through GitHub rather than provider defaults.
  allow_forking               = true
  allow_update_branch         = false
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  squash_merge_commit_message = "COMMIT_MESSAGES"
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  has_discussions             = false
  allow_merge_commit          = true
  allow_squash_merge          = true
  allow_rebase_merge          = true
  allow_auto_merge            = true
  delete_branch_on_merge      = true
  web_commit_signoff_required = false
  topics                      = ["approval-gates", "cerbo-gx", "dbus", "governance", "inverter-control", "policy-engine", "python", "soc-limits", "venus-os", "victron"]
}

resource "github_repository" "website" {
  name                        = "victron-venus.github.io"
  description                 = "Root-domain redirect — real site lives in victron-venus/.github"
  visibility                  = "public"
  archived                    = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  has_discussions             = false
  allow_merge_commit          = true
  allow_squash_merge          = true
  allow_rebase_merge          = true
  allow_auto_merge            = false
  delete_branch_on_merge      = false
  web_commit_signoff_required = false
  topics                      = []
}

locals {
  existing_admin_repositories = toset([
    "dbus-mqtt-battery", "dbus-tasmota-pv", "esphome-jbd-bms-mqtt", "inverter-control", "dbus-event-log",
  ])
  disabled_copilot_rulesets = {
    "dbus-tasmota-pv"     = "19344961"
    "inverter-control"    = "19446927"
    "inverter-dashboard"  = "19483917"
    "inverter-monitoring" = "19506308"
    "inverter-desktop"    = "19459711"
  }
  pages_repositories = toset([".github", "victron-venus.github.io"])
  pages_branch_policies = {
    ".github:gh-pages" = {
      repository = ".github"
      branch     = "gh-pages"
      id         = "58030077"
    }
    ".github:main" = {
      repository = ".github"
      branch     = "main"
      id         = "58030078"
    }
    "victron-venus.github.io:feature/redirect" = {
      repository = "victron-venus.github.io"
      branch     = "feature/redirect"
      id         = "58030350"
    }
    "victron-venus.github.io:main" = {
      repository = "victron-venus.github.io"
      branch     = "main"
      id         = "58030351"
    }
  }
}

resource "github_repository_ruleset" "disabled_copilot" {
  for_each    = local.disabled_copilot_rulesets
  name        = "Code Quality Copilot review for default branch"
  repository  = each.key
  target      = "branch"
  enforcement = "disabled"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }
  rules {
    copilot_code_review {
      review_on_push             = true
      review_draft_pull_requests = true
    }
  }
}

resource "github_repository_pages" "existing" {
  for_each   = local.pages_repositories
  repository = each.key
  build_type = "legacy"
  public     = true

  source {
    branch = "main"
    path   = "/"
  }
}

resource "github_repository_environment" "github_pages" {
  for_each          = local.pages_repositories
  repository        = each.key
  environment       = "github-pages"
  can_admins_bypass = true

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "github_pages" {
  for_each       = local.pages_branch_policies
  repository     = each.value.repository
  environment    = github_repository_environment.github_pages[each.value.repository].environment
  branch_pattern = each.value.branch
}


# Existing explicit grants to the organization owner, without inviting new users.
resource "github_repository_collaborator" "existing_admin" {
  for_each   = local.existing_admin_repositories
  repository = each.key
  username   = "4alvit"
  permission = "admin"
}

# Sensitive values are supplied by the canonical HCP workspace after verifying
# the live receiver. Do not configure GitHub's masked secret as a real value.
variable "existing_webhook_url" {
  description = "Current HTTPS URL for the existing inverter-monitoring webhook."
  type        = string
  sensitive   = true
  nullable    = false
  validation {
    condition     = startswith(var.existing_webhook_url, "https://")
    error_message = "The existing webhook URL must use HTTPS."
  }
}

variable "existing_webhook_secret" {
  description = "Existing signing secret verified against the live webhook receiver."
  type        = string
  sensitive   = true
  nullable    = false
  validation {
    condition     = trimspace(var.existing_webhook_secret) != "" && var.existing_webhook_secret != "********"
    error_message = "Supply the original receiver secret through a sensitive HCP variable, never GitHub's masked response."
  }
}

resource "github_repository_webhook" "inverter_monitoring" {
  repository = "inverter-monitoring"
  active     = true
  events     = ["push", "workflow_run"]
  configuration {
    url          = var.existing_webhook_url
    secret       = var.existing_webhook_secret
    content_type = "json"
    insecure_ssl = false
  }
}
