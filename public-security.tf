# Public software explicitly audited for the OpenSSF rollout. Private and archived
# repositories are excluded using live visibility before new rules are created.
variable "public_security_enforcement_repositories" {
  description = "Audited public repositories explicitly approved for additional governance enforcement."
  type        = set(string)
  default     = []
}

locals {
  public_software_repositories = toset([
    ".github",
    "SetupHelper",
    "dbus-emporia-vue",
    "dbus-esphome-grid-sensor",
    "dbus-ev",
    "dbus-event-log",
    "dbus-mqtt-battery",
    "dbus-pump",
    "dbus-tasmota-pv",
    "dbus-virtual-battery",
    "esphome-jbd-bms-mqtt",
    "integration-tests",
    "inverter-climate",
    "inverter-control",
    "inverter-dashboard",
    "inverter-dashboard-go",
    "inverter-dashboard-vue",
    "inverter-desktop",
    "inverter-gateway",
    "inverter-monitoring",
    "inverter-web-vitrine",
    "terraform-cloudflare-inverter-gateway",
    "venus-os-ci-toolkit",
    "venus-os-integration-patterns",
    "venus-os-observability"
  ])
  public_missing_review_repositories = toset([])
}

data "github_repository" "public_software" {
  for_each  = local.public_software_repositories
  full_name = "${var.github_organization}/${each.value}"
}

locals {
  active_public_software_repositories = toset([
    for repo, metadata in data.github_repository.public_software : repo
    if metadata.visibility == "public" && !metadata.archived
  ])
  enforced_public_software_repositories = setintersection(
    local.active_public_software_repositories,
    var.public_security_enforcement_repositories,
  )
}

resource "github_repository_ruleset" "public_review" {
  for_each = toset([
    for repo in local.public_missing_review_repositories : repo
    if contains(local.enforced_public_software_repositories, repo)
  ])
  name        = "Public software - required review"
  repository  = each.value
  target      = "branch"
  enforcement = "active"
  # The permanent owner exception below does not grant automation a bypass.
  # Organization owners retain permanent branch recovery authority.
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
  }
}
