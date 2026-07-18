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
# Organization Settings (managed manually via GitHub UI)
# =============================================================================
# Note: Organization settings require specific admin permissions
# and are better managed via GitHub UI for free tier accounts.
# Uncomment below if you have admin:org scope on your PAT.
#
# resource "github_organization_settings" "victron_venus" {
#   billing_email = var.billing_email
#   name          = "Victron Venus"
#   description   = "Open-source tools for Victron Energy systems and Venus OS"
#   ...
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
  description = "Organization profile and community resources"
  visibility  = "public"

  has_issues      = false
  has_projects    = false
  has_wiki        = false
  has_discussions = false

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

  depends_on = [github_repository.github_org]
}

resource "github_repository_file" "github_org_gitignore" {
  repository = github_repository.github_org.name
  branch     = "main"
  file       = ".gitignore"
  content    = file("${path.module}/files/github_org/.gitignore")

  depends_on = [github_repository.github_org]
}

# =============================================================================
# Repositories (External to Org)
# =============================================================================

# =============================================================================
# Branch Protection Rules
# =============================================================================

locals {
  protected_repos = {
    "inverter_control"      = github_repository.inverter_control.node_id
    "inverter_dashboard"    = github_repository.inverter_dashboard.node_id
    "inverter_dashboard_go" = github_repository.inverter_dashboard_go.node_id
    "dbus_mqtt_battery"     = github_repository.dbus_mqtt_battery.node_id
    "dbus_tasmota_pv"       = github_repository.dbus_tasmota_pv.node_id
    "esphome_jbd_bms_mqtt"  = github_repository.esphome_jbd_bms_mqtt.node_id
    "inverter_monitoring"   = github_repository.inverter_monitoring.node_id
    "integration_tests"     = github_repository.integration_tests.node_id
    "github_org"            = github_repository.github_org.node_id
  }
}

resource "github_branch_protection" "main" {
  for_each      = local.protected_repos
  repository_id = each.value
  pattern       = "main"

  enforce_admins                  = false
  allows_deletions                = false
  allows_force_pushes             = false
  require_conversation_resolution = true
  require_signed_commits          = true

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 1
  }
}

resource "github_branch_protection" "inverter_desktop" {
  repository_id = github_repository.inverter_desktop.node_id
  pattern       = "main"

  enforce_admins                  = false
  allows_deletions                = false
  allows_force_pushes             = false
  require_conversation_resolution = true
  require_signed_commits          = true

  required_status_checks {
    strict   = true
    contexts = ["cargo-audit", "frontend", "rust", "vitest"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 1
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

resource "github_repository_dependabot_security_updates" "inverter_monitoring" {
  repository = github_repository.inverter_monitoring.id
  enabled    = true
}

resource "github_repository_dependabot_security_updates" "integration_tests" {
  repository = github_repository.integration_tests.id
  enabled    = true
}

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
