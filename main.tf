terraform {
  required_version = ">= 1.0"

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
  allow_auto_merge   = false

  delete_branch_on_merge = false

  vulnerability_alerts = true

  topics = [
    "cerbo-gx", "dbus", "emporia-vue", "energy-management", "ess",
    "external-control", "grid-tie", "hass", "home-assistant", "python",
    "quattro", "raspberry-pi", "solar", "venus-os", "victron", "vm-3p75ct"
  ]

  license_template = "mit"
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

  delete_branch_on_merge = false

  vulnerability_alerts = true

  topics = [
    "cerbo-gx", "dashboard", "docker", "fastapi", "mqtt", "python",
    "real-time", "uplot", "venus-os", "victron", "vue", "websocket"
  ]

  license_template = "mit"
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
  allow_auto_merge   = false

  delete_branch_on_merge = false

  vulnerability_alerts = true

  topics = [
    "battery-management", "bms", "cerbo-gx", "dbus", "dvcc",
    "jbd-bms", "lifepo4", "mqtt", "python", "venus-os", "victron"
  ]

  license_template = "mit"
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
  allow_auto_merge   = false

  delete_branch_on_merge = false

  vulnerability_alerts = true

  topics = [
    "dbus", "mqtt", "pv-inverter", "python", "solar",
    "tasmota", "venus-os", "victron"
  ]

  license_template = "mit"
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
  allow_auto_merge   = false

  delete_branch_on_merge = false

  vulnerability_alerts = true

  topics = [
    "battery-monitor", "bluetooth", "cerbo-gx", "esp32", "esphome",
    "jbd-bms", "lifepo4", "mqtt", "venus-os", "victron"
  ]

  license_template = "mit"
}

# =============================================================================
# Branch Protection Rules (optional - uncomment if needed)
# =============================================================================
# Note: Branch protection requires GitHub Pro or public repos with specific settings.
# Uncomment and customize as needed.
#
# resource "github_branch_protection" "inverter_control_main" {
#   repository_id = github_repository.inverter_control.node_id
#   pattern       = "main"
#   required_status_checks {
#     strict   = true
#     contexts = ["Analyze"]
#   }
#   allows_deletions    = false
#   allows_force_pushes = false
# }

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
