terraform {

  required_version = ">= 1.15.7"

  # Remote state storage in Terraform Cloud (free tier)
  # Comment out this block for local state during initial setup
  cloud {
    organization = "victron-venus"

    workspaces {
      name = "github-infrastructure"
    }
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  owner = var.github_organization
  token = var.github_token
}

# =============================================================================
# Organization Settings
# =============================================================================
# Note: Organization settings require specific admin permissions
# and are better managed via GitHub UI for free tier accounts.
# Uncomment below if you have admin:org scope on your PAT.

# resource "github_organization_settings" "victron_venus" {
#   billing_email                 = var.billing_email
#   name                          = "Victron Venus"
#   description                   = "Open-source tools for Victron Energy systems and Venus OS"
#   blog                          = "https://github.com/victron-venus"
#   location                      = "Europe"
# }

# =============================================================================
# Repositories
# =============================================================================

resource "github_repository" "inverter_control" {
  name        = "inverter-control"
  description = "Grid-zero feed-in control for Victron inverters with Home Assistant integration and web dashboard"
  visibility  = "public"

  has_issues      = true
  has_projects    = true
  has_wiki        = true
  has_discussions = false

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true
  allow_auto_merge   = true

  delete_branch_on_merge = true


  topics = [
    "cerbo-gx", "dbus", "emporia-vue", "energy-management", "ess",
    "external-control", "grid-tie", "hass", "home-assistant", "python",
    "quattro", "raspberry-pi", "solar", "venus-os", "victron", "vm-3p75ct"
  ]

  license_template = "mit"
}

resource "github_repository_vulnerability_alerts" "inverter_control" {
  repository = github_repository.inverter_control.name
  depends_on = [github_repository.inverter_control]
}

resource "github_repository" "inverter_dashboard" {
  name        = "inverter-dashboard"
  description = "Real-time web dashboard for Victron inverter monitoring via MQTT"
  visibility  = "public"

  has_issues      = true
  has_projects    = true
  has_wiki        = true
  has_discussions = false

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true
  allow_auto_merge   = false

  delete_branch_on_merge = true


  topics = [
    "cerbo-gx", "dashboard", "docker", "fastapi", "mqtt", "python",
    "real-time", "uplot", "venus-os", "victron", "vue", "websocket"
  ]

  license_template = "mit"
}

resource "github_repository_vulnerability_alerts" "inverter_dashboard" {
  repository = github_repository.inverter_dashboard.name
  depends_on = [github_repository.inverter_dashboard]
}

resource "github_repository" "inverter_dashboard_go" {
  name        = "inverter-dashboard-go"
  description = "Real-time Victron inverter web dashboard (Go) — same role as inverter-dashboard, implemented in Go with MQTT and optional Home Assistant direct control"
  visibility  = "public"

  has_issues      = true
  has_projects    = true
  has_wiki        = true
  has_discussions = false

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true
  allow_auto_merge   = true

  delete_branch_on_merge = true


  topics = [
    "cerbo-gx", "dashboard", "docker", "go", "golang", "hass", "home-assistant",
    "mqtt", "real-time", "venus-os", "victron", "websocket"
  ]

  license_template = "mit"
}

resource "github_repository_vulnerability_alerts" "inverter_dashboard_go" {
  repository = github_repository.inverter_dashboard_go.name
  depends_on = [github_repository.inverter_dashboard_go]
}

resource "github_repository" "inverter_desktop" {
  name        = "inverter-desktop"
  description = "Desktop version of Web dashboard for Victron inverter control with Home Assistant integration"
  visibility  = "public"

  has_issues      = true
  has_projects    = true
  has_wiki        = true
  has_discussions = false

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true
  allow_auto_merge   = true

  delete_branch_on_merge = true


  topics = [
    "cerbo-gx", "dashboard", "energy-management", "grid-tie", "hass",
    "home-assistant", "mqtt", "venus-os", "victron", "web-dashboard"
  ]

  license_template = "mit"
}

resource "github_repository_vulnerability_alerts" "inverter_desktop" {
  repository = github_repository.inverter_desktop.name
  depends_on = [github_repository.inverter_desktop]
}

resource "github_repository" "inverter_dashboard_vue" {
  name        = "inverter-dashboard-vue"
  description = "Shared Vue 3 frontend SPA and reusable UI component library for Victron dashboards"
  visibility  = "public"

  has_issues      = true
  has_projects    = true
  has_wiki        = true
  has_discussions = false

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true
  allow_auto_merge   = true

  delete_branch_on_merge = true


  topics = [
    "dashboard", "echarts", "mqtt", "tailwindcss", "typescript",
    "venus-os", "victron", "vue", "vue3", "vite"
  ]

  license_template = "mit"
}

resource "github_repository_vulnerability_alerts" "inverter_dashboard_vue" {
  repository = github_repository.inverter_dashboard_vue.name
  depends_on = [github_repository.inverter_dashboard_vue]
}

resource "github_repository" "dbus_mqtt_battery" {
  name        = "dbus-mqtt-battery"
  description = "MQTT to D-Bus bridge for JBD BMS batteries on Victron Venus OS with DVCC support"
  visibility  = "public"

  has_issues      = true
  has_projects    = true
  has_wiki        = true
  has_discussions = false

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true
  allow_auto_merge   = true

  delete_branch_on_merge = true


  topics = [
    "battery-management", "bms", "cerbo-gx", "dbus", "dvcc",
    "jbd-bms", "lifepo4", "mqtt", "python", "venus-os", "victron"
  ]

  license_template = "mit"
}

resource "github_repository_vulnerability_alerts" "dbus_mqtt_battery" {
  repository = github_repository.dbus_mqtt_battery.name
  depends_on = [github_repository.dbus_mqtt_battery]
}

resource "github_repository" "dbus_tasmota_pv" {
  name        = "dbus-tasmota-pv"
  description = "Tasmota power meter to Victron D-Bus PV inverter bridge for Venus OS"
  visibility  = "public"

  has_issues      = true
  has_projects    = true
  has_wiki        = true
  has_discussions = false

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true
  allow_auto_merge   = true

  delete_branch_on_merge = true


  topics = [
    "dbus", "mqtt", "pv-inverter", "python", "solar",
    "tasmota", "venus-os", "victron"
  ]

  license_template = "mit"
}

resource "github_repository_vulnerability_alerts" "dbus_tasmota_pv" {
  repository = github_repository.dbus_tasmota_pv.name
  depends_on = [github_repository.dbus_tasmota_pv]
}

resource "github_repository" "esphome_jbd_bms_mqtt" {
  name        = "esphome-jbd-bms-mqtt"
  description = "ESPHome ESP32 Bluetooth proxy for JBD BMS batteries, publishing to MQTT for Victron Venus OS"
  visibility  = "public"

  has_issues      = true
  has_projects    = true
  has_wiki        = true
  has_discussions = false

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true
  allow_auto_merge   = true

  delete_branch_on_merge = true



  topics = [
    "battery-monitor", "bluetooth", "cerbo-gx", "esp32", "esphome",
    "jbd-bms", "lifepo4", "mqtt", "venus-os", "victron"
  ]

  license_template = "mit"
}

resource "github_repository_vulnerability_alerts" "esphome_jbd_bms_mqtt" {
  repository = github_repository.esphome_jbd_bms_mqtt.name
  depends_on = [github_repository.esphome_jbd_bms_mqtt]
}

resource "github_repository" "venus_os_observability" {
  name        = "venus-os-observability"
  description = "OpenTelemetry/Prometheus observability for Venus OS — D-Bus event tracing, inverter metrics, distributed tracing"
  visibility  = "public"

  has_issues      = true
  has_projects    = true
  has_wiki        = true
  has_discussions = false

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true
  allow_auto_merge   = true

  delete_branch_on_merge = true


  topics = [
    "cerbo-gx", "dbus", "distributed-tracing", "grafana", "mqtt",
    "opentelemetry", "prometheus", "tempo", "venus-os", "victron"
  ]

  license_template = "mit"
}

resource "github_repository_vulnerability_alerts" "venus_os_observability" {
  repository = github_repository.venus_os_observability.name
  depends_on = [github_repository.venus_os_observability]
}

resource "github_repository" "inverter_monitoring" {
  name        = "inverter-monitoring"
  description = "Telegraf + InfluxDB + Grafana monitoring stack for Victron inverter systems"
  visibility  = "public"

  has_issues      = true
  has_projects    = true
  has_wiki        = true
  has_discussions = false

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true
  allow_auto_merge   = true

  delete_branch_on_merge = true


  topics = [
    "cerbo-gx", "docker", "energy-monitoring", "grafana", "influxdb",
    "iot", "mqtt", "telegraf", "time-series", "venus-os", "victron"
  ]

  license_template = "mit"
}

resource "github_repository_vulnerability_alerts" "inverter_monitoring" {
  repository = github_repository.inverter_monitoring.name
  depends_on = [github_repository.inverter_monitoring]
}

resource "github_repository" "integration_tests" {
  name        = "integration-tests"
  description = "Integration tests for Victron Venus OS projects"
  visibility  = "public"

  has_issues      = true
  has_projects    = true
  has_wiki        = true
  has_discussions = false

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true
  allow_auto_merge   = true

  delete_branch_on_merge = true


  topics = [
    "ci", "integration-tests", "testing", "venus-os", "victron"
  ]

  license_template = "mit"
}

resource "github_repository_vulnerability_alerts" "integration_tests" {
  repository = github_repository.integration_tests.name
  depends_on = [github_repository.integration_tests]
}

resource "github_repository" "github_org" {
  name        = ".github"
  description = "Organization profile, install guide, and community resources"
  visibility  = "public"

  has_issues      = true
  has_projects    = false
  has_wiki        = false
  has_discussions = true

  allow_merge_commit = false
  allow_squash_merge = true
  allow_rebase_merge = false
  allow_auto_merge   = true

  delete_branch_on_merge = true


  topics = [
    "organization", "victron", "venus-os", "community"
  ]
}

resource "github_repository_file" "github_org_readme" {
  repository = github_repository.github_org.name
  branch     = "main"
  file       = "profile/README.md"
  content    = file("${path.module}/files/github_org/profile/README.md")

  lifecycle {
    ignore_changes = all
  }
}

resource "github_repository_file" "github_org_gitignore" {
  repository = github_repository.github_org.name
  branch     = "main"
  file       = ".gitignore"
  content    = file("${path.module}/files/github_org/.gitignore")

  lifecycle {
    ignore_changes = all
  }
}

resource "github_repository_file" "github_org_contributing" {
  repository = github_repository.github_org.name
  branch     = "main"
  file       = "CONTRIBUTING.md"
  content    = file("${path.module}/files/github_org/CONTRIBUTING.md")

  lifecycle {
    ignore_changes = all
  }
}

resource "github_repository_file" "github_org_install" {
  repository = github_repository.github_org.name
  branch     = "main"
  file       = "docs/INSTALL.md"
  content    = file("${path.module}/files/github_org/docs/INSTALL.md")

  lifecycle {
    ignore_changes = all
  }
}

# =============================================================================
# Repositories (External to Org)
# =============================================================================

# =============================================================================
# Branch Protection Rulesets
# =============================================================================

data "github_app" "gitar" {
  slug = "gitar-bot"
}

resource "github_repository_ruleset" "default" {
  name        = "Default"
  repository  = "inverter-desktop"
  target      = "branch"
  enforcement = "active"

  bypass_actors {
    actor_id    = 5
    actor_type  = "RepositoryRole"
    bypass_mode = "always"
  }

  bypass_actors {
    actor_id    = data.github_app.gitar.id
    actor_type  = "Integration"
    bypass_mode = "always"
  }

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    deletion            = true
    non_fast_forward    = true
    required_signatures = true

    copilot_code_review {
      review_draft_pull_requests = true
      review_on_push             = true
    }

    pull_request {
      allowed_merge_methods             = ["merge", "squash", "rebase"]
      dismiss_stale_reviews_on_push     = false
      require_code_owner_review         = true
      require_last_push_approval        = true
      required_approving_review_count   = 1
      required_review_thread_resolution = true
    }

    required_code_scanning {
      required_code_scanning_tool {
        alerts_threshold          = "errors"
        security_alerts_threshold = "high_or_higher"
        tool                      = "CodeQL"
      }
    }
  }
}

locals {
  remaining_repos = [
    "inverter-control",
    "inverter-dashboard",
    "inverter-dashboard-go",
    "inverter-dashboard-vue",
    "dbus-mqtt-battery",
    "dbus-tasmota-pv",
    "esphome-jbd-bms-mqtt",
    "venus-os-observability",
    "inverter-monitoring",
    "integration-tests",
    ".github",
  ]
}

resource "github_repository_ruleset" "default_remaining" {
  for_each    = toset(local.remaining_repos)
  name        = "Default"
  repository  = each.value
  target      = "branch"
  enforcement = "active"

  bypass_actors {
    actor_id    = 5
    actor_type  = "RepositoryRole"
    bypass_mode = "always"
  }

  bypass_actors {
    actor_id    = data.github_app.gitar.id
    actor_type  = "Integration"
    bypass_mode = "always"
  }

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    deletion            = true
    non_fast_forward    = true
    required_signatures = true

    copilot_code_review {
      review_draft_pull_requests = true
      review_on_push             = true
    }

    pull_request {
      allowed_merge_methods             = ["merge", "squash", "rebase"]
      dismiss_stale_reviews_on_push     = false
      require_code_owner_review         = true
      require_last_push_approval        = true
      required_approving_review_count   = 1
      required_review_thread_resolution = true
    }

    required_code_scanning {
      required_code_scanning_tool {
        alerts_threshold          = "errors"
        security_alerts_threshold = "high_or_higher"
        tool                      = "CodeQL"
      }
    }
  }
}

# =============================================================================
# Repository Security Settings
# =============================================================================

resource "github_repository_dependabot_security_updates" "inverter_control" {
  repository = github_repository.inverter_control.id
  enabled    = true
}

resource "github_repository_dependabot_security_updates" "inverter_dashboard" {
  repository = github_repository.inverter_dashboard.id
  enabled    = true
}

resource "github_repository_dependabot_security_updates" "inverter_dashboard_go" {
  repository = github_repository.inverter_dashboard_go.id
  enabled    = true
}

resource "github_repository_dependabot_security_updates" "inverter_desktop" {
  repository = github_repository.inverter_desktop.id
  enabled    = true
}

resource "github_repository_dependabot_security_updates" "inverter_dashboard_vue" {
  repository = github_repository.inverter_dashboard_vue.id
  enabled    = true
}

resource "github_repository_dependabot_security_updates" "dbus_mqtt_battery" {
  repository = github_repository.dbus_mqtt_battery.id
  enabled    = true
}

resource "github_repository_dependabot_security_updates" "dbus_tasmota_pv" {
  repository = github_repository.dbus_tasmota_pv.id
  enabled    = true
}

resource "github_repository_dependabot_security_updates" "esphome_jbd_bms_mqtt" {
  repository = github_repository.esphome_jbd_bms_mqtt.id
  enabled    = true
}

resource "github_repository_dependabot_security_updates" "venus_os_observability" {
  repository = github_repository.venus_os_observability.id
  enabled    = true
}

resource "github_repository_dependabot_security_updates" "inverter_monitoring" {
  repository = github_repository.inverter_monitoring.id
  enabled    = true
}

resource "github_repository_dependabot_security_updates" "integration_tests" {
  repository = github_repository.integration_tests.id
  enabled    = true
}

# Secret Scanning & Push Protection - Enable via GitHub UI or API
# Resources not available in github provider v6.13 - enable manually at:
# https://github.com/organizations/victron-venus/settings/security
# Or via REST API: PUT /repos/{owner}/{repo}/secret-scanning/alerts

# =============================================================================
# Actions Secrets (optional - for Docker publishing)
# =============================================================================
# Actions Secrets (optional - for Docker publishing)
# =============================================================================
# Note: Organization secrets require admin permissions.
# For repository-level secrets, use github_actions_secret instead.
#
# resource "github_actions_organization_secret" "ghcr_token" {
#   secret_name     = "GHCR_TOKEN"
#   visibility      = "all"
#   plaintext_value = var.ghcr_token
# }
