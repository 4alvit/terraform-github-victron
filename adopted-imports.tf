# Explicit IDs retain the audit trail for infrastructure adopted into this workspace.

import {
  to = github_repository.venus_os_governance
  id = "venus-os-governance"
}

import {
  to = github_repository.website
  id = "victron-venus.github.io"
}

import {
  for_each = local.disabled_copilot_rulesets
  to       = github_repository_ruleset.disabled_copilot[each.key]
  id       = "${each.key}:${each.value}"
}

import {
  to = github_repository_ruleset.default_remaining["venus-os-governance"]
  id = "venus-os-governance:20199488"
}

import {
  for_each = local.pages_repositories
  to       = github_repository_pages.existing[each.key]
  id       = each.key
}

import {
  for_each = local.pages_repositories
  to       = github_repository_environment.github_pages[each.key]
  id       = "${each.key}:github-pages"
}

import {
  for_each = local.pages_branch_policies
  to       = github_repository_environment_deployment_policy.github_pages[each.key]
  id       = "${each.value.repository}:github-pages:${each.value.id}"
}

import {
  for_each = local.existing_admin_repositories
  to       = github_repository_collaborator.existing_admin[each.key]
  id       = "${each.key}:4alvit"
}

import {
  to = github_repository_webhook.inverter_monitoring
  id = "inverter-monitoring/605430998"
}
