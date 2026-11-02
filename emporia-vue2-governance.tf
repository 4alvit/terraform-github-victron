# This existing public repository uses its own validator/firmware workflow,
# not the application release workflow's "CI gate" check.
data "github_repository" "emporia_vue2_governance" {
  full_name = "${var.github_organization}/esphome-emporia-vue2-ethernet"
}

resource "github_repository_ruleset" "emporia_vue2_governance" {
  count = data.github_repository.emporia_vue2_governance.visibility == "public" && !data.github_repository.emporia_vue2_governance.archived ? 1 : 0

  name        = "Ethernet examples - reviewed and validated changes"
  repository  = "esphome-emporia-vue2-ethernet"
  target      = "branch"
  enforcement = "active"

  bypass_actors {
    actor_id    = local.owner_emergency_merge_actor.actor_id
    actor_type  = local.owner_emergency_merge_actor.actor_type
    bypass_mode = local.owner_emergency_merge_actor.bypass_mode
  }

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    deletion         = true
    non_fast_forward = true

    pull_request {
      required_approving_review_count   = 1
      dismiss_stale_reviews_on_push     = true
      require_last_push_approval        = true
      required_review_thread_resolution = true
    }

    required_status_checks {
      strict_required_status_checks_policy = true
      do_not_enforce_on_create             = false
      required_check {
        context        = "Documentation and examples"
        integration_id = 15368
      }
      required_check {
        context        = "ESPHome configuration and generation"
        integration_id = 15368
      }
      required_check {
        context        = "CodeQL"
        integration_id = 57789
      }
    }
  }
}
