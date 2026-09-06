terraform {
  required_version = ">= 1.15.7"

  # Remote state storage in Terraform Cloud (free tier)
  # Comment out this block for local state during initial setup
  cloud {
    organization = "alvit"

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

locals {
  repositories = {
    inverter_control = {
      name                        = "inverter-control"
      description                 = "Grid-zero feed-in control for Victron inverters with Home Assistant integration and web dashboard"
      topics                      = ["cerbo-gx", "dbus", "emporia-vue", "energy-management", "ess", "external-control", "grid-tie", "hass", "home-assistant", "mqtt", "python", "quattro", "raspberry-pi", "solar", "venus-os", "victron", "vm-3p75ct"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    inverter_dashboard = {
      name                        = "inverter-dashboard"
      description                 = "Real-time web dashboard for Victron inverter monitoring via MQTT"
      topics                      = ["cerbo-gx", "dashboard", "docker", "fastapi", "mqtt", "python", "real-time", "uplot", "venus-os", "victron", "vue", "websocket"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    inverter_dashboard_go = {
      name                        = "inverter-dashboard-go"
      description                 = "Real-time Victron inverter web dashboard (Go) — same role as inverter-dashboard, implemented in Go with MQTT and optional Home Assistant direct control"
      topics                      = ["cerbo-gx", "dashboard", "docker", "go", "golang", "hass", "home-assistant", "mqtt", "real-time", "venus-os", "victron", "websocket"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    inverter_desktop = {
      name                        = "inverter-desktop"
      description                 = "Desktop version of Web dashboard for Victron inverter control with Home Assistant integration"
      topics                      = ["cerbo-gx", "dashboard", "energy-management", "grid-tie", "hass", "home-assistant", "mqtt", "venus-os", "victron", "web-dashboard"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    inverter_gateway = {
      name                        = "inverter-gateway"
      description                 = "Remote HTTPS/SSE gateway for Victron Cerbo MQTT — Cloudflare Tunnel edge on Synology; used by inverter-desktop remote profile"
      topics                      = ["cerbo-gx", "cloudflare", "docker", "energy-management", "gateway", "mqtt", "rust", "synology", "victron", "venus-os"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    inverter_dashboard_vue = {
      name                        = "inverter-dashboard-vue"
      description                 = "Shared Vue 3 frontend SPA and reusable UI component library for Victron dashboards"
      topics                      = ["dashboard", "echarts", "mqtt", "tailwindcss", "typescript", "venus-os", "victron", "vue", "vue3", "vite"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    dbus_mqtt_battery = {
      name                        = "dbus-mqtt-battery"
      description                 = "MQTT to D-Bus bridge for JBD BMS batteries on Victron Venus OS with DVCC support"
      topics                      = ["battery-management", "bms", "cerbo-gx", "dbus", "dvcc", "jbd-bms", "lifepo4", "mqtt", "python", "venus-os", "victron"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    dbus_tasmota_pv = {
      name                        = "dbus-tasmota-pv"
      description                 = "Tasmota power meter to Victron D-Bus PV inverter bridge for Venus OS"
      topics                      = ["dbus", "mqtt", "pv-inverter", "python", "solar", "tasmota", "venus-os", "victron"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    dbus_emporia_vue = {
      name                        = "dbus-emporia-vue"
      description                 = "Emporia Vue submeter channels as individual Victron D-Bus AC loads for Venus OS — Home Assistant WebSocket power data via com.victronenergy.acload services"
      topics                      = ["acload", "cerbo-gx", "dbus", "emporia-vue", "energy-management", "hass", "home-assistant", "python", "submetering", "venus-os", "victron", "websocket"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    esphome_jbd_bms_mqtt = {
      name                        = "esphome-jbd-bms-mqtt"
      description                 = "ESPHome ESP32 Bluetooth proxy for JBD BMS batteries, publishing to MQTT for Victron Venus OS"
      topics                      = ["battery-monitor", "bluetooth", "cerbo-gx", "esp32", "esphome", "jbd-bms", "lifepo4", "mqtt", "venus-os", "victron"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    venus_os_observability = {
      name                        = "venus-os-observability"
      description                 = "OpenTelemetry/Prometheus observability for Venus OS — D-Bus event tracing, inverter metrics, distributed tracing"
      topics                      = ["cerbo-gx", "dbus", "distributed-tracing", "grafana", "mqtt", "opentelemetry", "prometheus", "python", "tempo", "venus-os", "victron"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    inverter_monitoring = {
      name                        = "inverter-monitoring"
      description                 = "Telegraf + InfluxDB + Grafana monitoring stack for Victron inverter systems"
      topics                      = ["cerbo-gx", "docker", "energy-monitoring", "grafana", "influxdb", "iot", "mqtt", "python", "telegraf", "time-series", "venus-os", "victron"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    integration_tests = {
      name                        = "integration-tests"
      description                 = "Integration tests for Victron Venus OS projects"
      topics                      = ["ci", "integration-tests", "mqtt", "python", "testing", "venus-os", "victron"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    dbus_event_log = {
      name                        = "dbus-event-log"
      description                 = "Audit log for D-Bus commands and inverter state transitions with chronology, filtering, and export — SQLite/TimescaleDB storage, MQTT publishing, CLI query tool, Grafana dashboards"
      topics                      = ["audit-log", "cerbo-gx", "dbus", "inverter", "mqtt", "python", "sqlite", "timescaledb", "venus-os", "victron"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    dbus_esphome_grid_sensor = {
      name                        = "dbus-esphome-grid-sensor"
      description                 = "ESP32 CT sensor for grid power monitoring with D-Bus service for Venus OS"
      topics                      = ["esp32", "esphome", "ct-sensor", "grid-meter", "mqtt", "dbus", "venus-os", "victron", "docker", "python", "home-automation"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    venus_os_integration_patterns = {
      name                        = "venus-os-integration-patterns"
      description                 = "Reference implementations for common Venus OS integrations — MQTT↔D-Bus bridges, HTTP API wrappers, scheduled control, Home Assistant automations"
      topics                      = ["cerbo-gx", "dbus", "fastapi", "ha-automation", "home-assistant", "integration-patterns", "mqtt", "python", "venus-os", "victron"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    venus_os_ci_toolkit = {
      name                        = "venus-os-ci-toolkit"
      description                 = "Reusable GitHub Actions workflows and CI tooling for Victron Venus OS projects"
      topics                      = ["ci", "github-actions", "github-workflows", "venus-os", "victron", "docker", "python", "go", "testing", "reusable-workflows"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    setup_helper = {
      name                        = "SetupHelper"
      description                 = "Helper scripts for Victron Venus OS setup and configuration"
      topics                      = ["venus-os", "victron", "setup", "helper", "scripts"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    github_org = {
      name                        = ".github"
      description                 = "Organization profile, install guide, and community resources"
      has_issues                  = true
      has_projects                = false
      has_wiki                    = false
      has_discussions             = true
      allow_merge_commit          = false
      allow_squash_merge          = true
      allow_rebase_merge          = false
      allow_auto_merge            = true
      delete_branch_on_merge      = true
      topics                      = ["organization", "victron", "venus-os", "community"]
      license_template            = null
      vulnerability_alerts        = false
      dependabot_security_updates = false
    }
    dbus_virtual_battery = {
      name                        = "dbus-virtual-battery"
      description                 = "DBus Virtual Battery Calculator for chains without BMS (used by dbus-mqtt-battery)"
      topics                      = ["battery", "simulator", "test", "venus-os", "victron", "dbus", "mqtt"]
      vulnerability_alerts        = true
      dependabot_security_updates = false
    }
    dbus_pump = {
      name                        = "dbus-pump"
      description                 = "Home-Assistant-backed water tank/pump/valve bridge for Victron Venus OS (Cerbo GX)"
      topics                      = ["cerbo-gx", "dbus", "home-assistant", "mqtt", "python", "venus-os", "victron", "water-management"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    dbus_evcharger = {
      name                        = "dbus-evcharger"
      description                 = "Venus OS D-Bus EV charger (wallbox) service publishing com.victronenergy.evcharger for VRM/GUIv2"
      topics                      = ["cerbo-gx", "dbus", "ev", "evcharger", "python", "venus-os", "victron"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
    dbus_ev = {
      name                        = "dbus-ev"
      description                 = "Venus OS D-Bus EV vehicle service publishing com.victronenergy.ev (SoC, range) for VRM/GUIv2"
      topics                      = ["cerbo-gx", "dbus", "ev", "python", "venus-os", "victron"]
      vulnerability_alerts        = true
      dependabot_security_updates = true
    }
  }
}

module "repos" {
  source   = "./modules/github_repo"
  for_each = local.repositories

  name                        = each.value.name
  description                 = each.value.description
  has_issues                  = lookup(each.value, "has_issues", true)
  has_projects                = lookup(each.value, "has_projects", true)
  has_wiki                    = lookup(each.value, "has_wiki", true)
  has_discussions             = lookup(each.value, "has_discussions", false)
  allow_merge_commit          = lookup(each.value, "allow_merge_commit", true)
  allow_squash_merge          = lookup(each.value, "allow_squash_merge", true)
  allow_rebase_merge          = lookup(each.value, "allow_rebase_merge", true)
  allow_auto_merge            = lookup(each.value, "allow_auto_merge", true)
  delete_branch_on_merge      = lookup(each.value, "delete_branch_on_merge", true)
  topics                      = each.value.topics
  license_template            = lookup(each.value, "license_template", "mit")
  vulnerability_alerts        = each.value.vulnerability_alerts
  dependabot_security_updates = each.value.dependabot_security_updates
}

# =============================================================================
# State relocation
# =============================================================================
# The GitHub provider blocks all `moved {}` (even same-type) and the ruleset
# `moved` here is between two instances of the same resource, which core TF
# supports but the provider may reject. Run `terraform state mv` for every
# existing address to its module instance equivalent before the first apply.
#
#   github_repository.X
#     → module.repos["X"].github_repository.this
#   github_repository_vulnerability_alerts.X
#     → module.repos["X"].github_repository_vulnerability_alerts.this[0]
#   github_repository_dependabot_security_updates.X
#     → module.repos["X"].github_repository_dependabot_security_updates.this[0]
#   github_repository_ruleset.default_remaining["virtual-battery"]
#     → github_repository_ruleset.default_remaining["dbus-virtual-battery"]
#
# See STATE_MIGRATION.md for the full command list.

# =============================================================================
# Archived: venus-os-governance resources must be removed from state without
# destruction. Use `removed` blocks (not moved) so Terraform drops them from
# state and leaves the GitHub side untouched.
# =============================================================================
removed {
  from = github_repository.venus_os_governance

  lifecycle {
    destroy = false
  }
}

removed {
  from = github_repository_vulnerability_alerts.venus_os_governance

  lifecycle {
    destroy = false
  }
}

removed {
  from = github_repository_dependabot_security_updates.venus_os_governance

  lifecycle {
    destroy = false
  }
}

# =============================================================================
# Organization-level settings
# =============================================================================

resource "github_actions_organization_workflow_permissions" "victron_venus" {
  organization_slug                = "victron-venus"
  default_workflow_permissions     = "write"
  can_approve_pull_request_reviews = true
}

# =============================================================================
# .github org profile files (keep at root — these target a specific repo)
# =============================================================================

resource "github_repository_file" "github_org_readme" {
  repository = module.repos["github_org"].repository.name
  branch     = "main"
  file       = "profile/README.md"
  content    = file("${path.module}/files/github_org/profile/README.md")

  lifecycle {
    ignore_changes = all
  }
}

resource "github_repository_file" "github_org_gitignore" {
  repository = module.repos["github_org"].repository.name
  branch     = "main"
  file       = ".gitignore"
  content    = file("${path.module}/files/github_org/.gitignore")

  lifecycle {
    ignore_changes = all
  }
}

resource "github_repository_file" "github_org_contributing" {
  repository = module.repos["github_org"].repository.name
  branch     = "main"
  file       = "CONTRIBUTING.md"
  content    = file("${path.module}/files/github_org/CONTRIBUTING.md")

  lifecycle {
    ignore_changes = all
  }
}

resource "github_repository_file" "github_org_install" {
  repository = module.repos["github_org"].repository.name
  branch     = "main"
  file       = "docs/INSTALL.md"
  content    = file("${path.module}/files/github_org/docs/INSTALL.md")

  lifecycle {
    ignore_changes = all
  }
}

# =============================================================================
# Branch Protection Rulesets
# =============================================================================

locals {
  remaining_repos = [
    "inverter-control",
    "inverter-dashboard",
    "inverter-dashboard-go",
    "inverter-dashboard-vue",
    "inverter-gateway",
    "dbus-mqtt-battery",
    "dbus-tasmota-pv",
    "dbus-event-log",
    "dbus-emporia-vue",
    "esphome-jbd-bms-mqtt",
    "venus-os-observability",
    "venus-os-integration-patterns",
    "venus-os-ci-toolkit",
    "inverter-monitoring",
    "integration-tests",
    "dbus-esphome-grid-sensor",
    ".github",
    "dbus-virtual-battery",
    "SetupHelper",
    "dbus-pump",
    "dbus-evcharger",
    "dbus-ev",
  ]
}

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
