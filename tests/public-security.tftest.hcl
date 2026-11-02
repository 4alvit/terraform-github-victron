mock_provider "github" {
  override_during = plan
  mock_data "github_repository" {
    defaults = {
      visibility = "public"
      archived   = false
    }
  }
}

run "review_requires_one_current_approval_with_owner_exception" {
  command = plan
  assert {
    condition = alltrue([
      for policy in github_repository_ruleset.public_review : (
        (
          length([for actor in policy.bypass_actors : actor if actor.actor_type == local.owner_emergency_merge_actor.actor_type]) == 1 &&
          alltrue([
            for actor in policy.bypass_actors :
            coalesce(actor.actor_id, 0) == coalesce(local.owner_emergency_merge_actor.actor_id, 0) && actor.bypass_mode == "always"
            if actor.actor_type == local.owner_emergency_merge_actor.actor_type
          ]) &&
          length([for actor in policy.bypass_actors : actor if actor.actor_type != local.owner_emergency_merge_actor.actor_type]) == 0
        ) &&
        one(one(policy.rules).pull_request).required_approving_review_count == 1 &&
        one(one(policy.rules).pull_request).dismiss_stale_reviews_on_push &&
        one(one(policy.rules).pull_request).require_last_push_approval &&
        one(one(policy.rules).pull_request).required_review_thread_resolution
      )
    ])
    error_message = "New public review rules must preserve current reviews and grant permanent bypass only to the owner."
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

run "permanent_branch_bypass_is_limited_to_the_owner" {
  command = plan
  assert {
    condition = (
      local.owner_emergency_merge_actor.actor_type == "OrganizationAdmin" &&
      local.owner_emergency_merge_actor.actor_id == null &&
      local.owner_emergency_merge_actor.bypass_mode == "always"
    )
    error_message = "Only the declared organization owner receives permanent branch bypass; no repository-role or automation grants are added."
  }
}

run "ethernet_requires_review_and_its_real_checks" {
  command = plan
  assert {
    condition = (
      length(github_repository_ruleset.emporia_vue2_governance) == 1 &&
      github_repository_ruleset.emporia_vue2_governance[0].repository == "esphome-emporia-vue2-ethernet" &&
      github_repository_ruleset.emporia_vue2_governance[0].enforcement == "active" &&
      length(github_repository_ruleset.emporia_vue2_governance[0].bypass_actors) == 1 &&
      one(github_repository_ruleset.emporia_vue2_governance[0].bypass_actors).actor_type == "OrganizationAdmin" &&
      one(github_repository_ruleset.emporia_vue2_governance[0].bypass_actors).bypass_mode == "always" &&
      one(one(github_repository_ruleset.emporia_vue2_governance[0].rules).pull_request).required_approving_review_count == 1 &&
      one(one(github_repository_ruleset.emporia_vue2_governance[0].rules).pull_request).dismiss_stale_reviews_on_push &&
      one(one(github_repository_ruleset.emporia_vue2_governance[0].rules).pull_request).require_last_push_approval &&
      one(one(github_repository_ruleset.emporia_vue2_governance[0].rules).pull_request).required_review_thread_resolution &&
      one(one(github_repository_ruleset.emporia_vue2_governance[0].rules).required_status_checks).strict_required_status_checks_policy &&
      { for check in one(one(github_repository_ruleset.emporia_vue2_governance[0].rules).required_status_checks).required_check : check.context => check.integration_id } == {
        "Documentation and examples"           = 15368
        "ESPHome configuration and generation" = 15368
        "CodeQL"                               = 57789
      }
    )
    error_message = "Ethernet changes require current review, owner-only recovery and exactly the three real qualified checks."
  }
}

run "ethernet_private_repository_is_excluded" {
  command = plan
  override_data {
    target = data.github_repository.emporia_vue2_governance
    values = {
      visibility = "private"
      archived   = false
    }
  }
  assert {
    condition     = length(github_repository_ruleset.emporia_vue2_governance) == 0
    error_message = "Do not create public governance rules for a private Ethernet repository."
  }
}

run "ethernet_archived_repository_is_excluded" {
  command = plan
  override_data {
    target = data.github_repository.emporia_vue2_governance
    values = {
      visibility = "public"
      archived   = true
    }
  }
  assert {
    condition     = length(github_repository_ruleset.emporia_vue2_governance) == 0
    error_message = "Do not create new rules for an archived Ethernet repository."
  }
}
