mock_provider "github" {
  override_during = plan
  mock_data "github_repository" {
    defaults = {
      visibility = "public"
      archived   = false
    }
  }
}

run "review_requires_one_current_approval_without_bypass" {
  command = plan
  assert {
    condition = alltrue([
      for policy in github_repository_ruleset.public_review : (
        length(policy.bypass_actors) == 0 &&
        one(one(policy.rules).pull_request).required_approving_review_count == 1 &&
        one(one(policy.rules).pull_request).dismiss_stale_reviews_on_push &&
        one(one(policy.rules).pull_request).require_last_push_approval &&
        one(one(policy.rules).pull_request).required_review_thread_resolution
      )
    ])
    error_message = "New public review rules must have no administrator/bot bypass and require current reviews."
  }
}

run "inventory_does_not_implicitly_enable_enforcement" {
  command = plan
  assert {
    condition     = length(local.enforced_public_software_repositories) == 0
    error_message = "Inventory membership must not opt a repository into new governance enforcement."
  }
}

run "explicit_enforcement_is_limited_to_audited_repositories" {
  command = plan
  variables {
    public_security_enforcement_repositories = [".github", "unreviewed-repository"]
  }
  assert {
    condition     = local.enforced_public_software_repositories == toset([".github"])
    error_message = "Only explicitly selected, audited public repositories may receive additional enforcement."
  }
}

run "private_repository_is_excluded" {
  command = plan
  variables {
    public_security_enforcement_repositories = [".github"]
  }
  override_data {
    target = data.github_repository.public_software[".github"]
    values = {
      visibility = "private"
      archived   = false
    }
  }
  assert {
    condition     = !contains(local.enforced_public_software_repositories, ".github") && !contains(local.active_public_software_repositories, ".github") && !contains(keys(github_repository_ruleset.public_review), ".github")
    error_message = "Do not apply public security rules to private repositories."
  }
}

run "archived_repository_is_excluded" {
  command = plan
  variables {
    public_security_enforcement_repositories = [".github"]
  }
  override_data {
    target = data.github_repository.public_software[".github"]
    values = {
      visibility = "public"
      archived   = true
    }
  }
  assert {
    condition     = !contains(local.enforced_public_software_repositories, ".github") && !contains(local.active_public_software_repositories, ".github") && !contains(keys(github_repository_ruleset.public_review), ".github")
    error_message = "Do not change archived repository protections."
  }
}
