variables {
  existing_webhook_url    = "https://example.invalid/webhook"
  existing_webhook_secret = "test-fixture-not-a-live-secret"
}

mock_provider "github" {}

run "adopt_existing_repository_and_review_policy" {
  command = plan

  assert {
    condition = (
      github_repository.venus_os_governance.archived &&
      github_repository.venus_os_governance.allow_auto_merge &&
      !github_repository.website.archived &&
      !github_repository.website.allow_auto_merge &&
      !github_repository.website.delete_branch_on_merge
    )
    error_message = "Adoption must retain the archived repository and existing website merge settings."
  }

  assert {
    condition = length(github_repository_ruleset.disabled_copilot) == 5 && alltrue([
      for rule in github_repository_ruleset.disabled_copilot :
      rule.target == "branch" && rule.enforcement == "disabled" && length(rule.bypass_actors) == 0
    ])
    error_message = "Existing optional Copilot rules must remain disabled."
  }

  assert {
    condition = length(github_repository_collaborator.existing_admin) == 5 && alltrue([
      for grant in github_repository_collaborator.existing_admin :
      grant.username == "4alvit" && grant.permission == "admin"
    ])
    error_message = "Adoption must preserve the five existing administrator grants."
  }
}

run "adopt_existing_pages_policy" {
  command = plan

  assert {
    condition = length(github_repository_pages.existing) == 2 && alltrue([
      for site in github_repository_pages.existing :
      site.build_type == "legacy" && site.public && site.source[0].branch == "main" && site.source[0].path == "/"
    ])
    error_message = "Pages must retain its existing source, path and public visibility."
  }

  assert {
    condition = length(github_repository_environment.github_pages) == 2 && alltrue([
      for environment in github_repository_environment.github_pages :
      environment.environment == "github-pages" && environment.can_admins_bypass &&
      !environment.deployment_branch_policy[0].protected_branches &&
      environment.deployment_branch_policy[0].custom_branch_policies && length(environment.reviewers) == 0
    ])
    error_message = "Adoption must retain the current Pages environment policy."
  }

  assert {
    condition = toset([
      for policy in github_repository_environment_deployment_policy.github_pages :
      "${policy.repository}:${policy.branch_pattern}"
      ]) == toset([
      ".github:gh-pages", ".github:main",
      "victron-venus.github.io:feature/redirect", "victron-venus.github.io:main",
    ])
    error_message = "Adoption must preserve exactly the four observed Pages deployment branch policies."
  }
}

run "adopt_active_webhook_without_changing_delivery" {
  command = plan

  assert {
    condition = (
      github_repository_webhook.inverter_monitoring.repository == "inverter-monitoring" &&
      github_repository_webhook.inverter_monitoring.active &&
      github_repository_webhook.inverter_monitoring.events == toset(["push", "workflow_run"]) &&
      github_repository_webhook.inverter_monitoring.configuration[0].content_type == "json" &&
      !github_repository_webhook.inverter_monitoring.configuration[0].insecure_ssl &&
      github_repository_webhook.inverter_monitoring.configuration[0].secret == var.existing_webhook_secret
    )
    error_message = "Keep the active webhook's events, JSON delivery, certificate checks and verified receiver secret."
  }
}

run "masked_webhook_secret_is_rejected" {
  command = plan
  variables {
    existing_webhook_secret = "********"
  }
  expect_failures = [var.existing_webhook_secret]
}
