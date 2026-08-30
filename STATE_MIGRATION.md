# State Migration Guide

This refactor moves all `github_repository` resources (and their
`vulnerability_alerts` / `dependabot_security_updates` children) from flat
resource blocks into the `module.repos` for_each.

**Problem:** The `integrations/github` provider (v6.x) does not support
`moved {}` across module boundaries — even same-type moves are rejected.
`moved {}` blocks are present in the code for documentation but cannot be
resolved by the provider. A two-phase migration is required.

## Phase 1: Commit code (this PR)

The code is structurally correct:
- `module.repos` creates all repos with the same settings
- `removed {}` blocks prevent destruction of the old `venus-os-governance`
  resources that were archived
- Old flat resource blocks are removed

## Phase 2: Migrate state (run before `terraform apply`)

Run each `terraform state mv` command below **once**, targeting the
Terraform Cloud workspace `victron-venus/github-infrastructure`.
These must be run after the PR is merged and before the first apply.

You need `github_token` set (from `TF_VAR_github_token` or environment)
and the Terraform Cloud token configured (`terraform login` or
`TF_API_TOKEN`).

```bash
# ── github_repository → module ───────────────────────────────────────────────
# inverter_control
terraform state mv github_repository.inverter_control module.repos["inverter_control"].github_repository.this

# inverter_dashboard
terraform state mv github_repository.inverter_dashboard module.repos["inverter_dashboard"].github_repository.this

# inverter_dashboard_go
terraform state mv github_repository.inverter_dashboard_go module.repos["inverter_dashboard_go"].github_repository.this

# inverter_desktop
terraform state mv github_repository.inverter_desktop module.repos["inverter_desktop"].github_repository.this

# inverter_dashboard_vue
terraform state mv github_repository.inverter_dashboard_vue module.repos["inverter_dashboard_vue"].github_repository.this

# dbus_mqtt_battery
terraform state mv github_repository.dbus_mqtt_battery module.repos["dbus_mqtt_battery"].github_repository.this

# dbus_tasmota_pv
terraform state mv github_repository.dbus_tasmota_pv module.repos["dbus_tasmota_pv"].github_repository.this

# dbus_emporia_vue
terraform state mv github_repository.dbus_emporia_vue module.repos["dbus_emporia_vue"].github_repository.this

# esphome_jbd_bms_mqtt
terraform state mv github_repository.esphome_jbd_bms_mqtt module.repos["esphome_jbd_bms_mqtt"].github_repository.this

# venus_os_observability
terraform state mv github_repository.venus_os_observability module.repos["venus_os_observability"].github_repository.this

# inverter_monitoring
terraform state mv github_repository.inverter_monitoring module.repos["inverter_monitoring"].github_repository.this

# integration_tests
terraform state mv github_repository.integration_tests module.repos["integration_tests"].github_repository.this

# dbus_event_log
terraform state mv github_repository.dbus_event_log module.repos["dbus_event_log"].github_repository.this

# dbus_esphome_grid_sensor
terraform state mv github_repository.dbus_esphome_grid_sensor module.repos["dbus_esphome_grid_sensor"].github_repository.this

# venus_os_integration_patterns
terraform state mv github_repository.venus_os_integration_patterns module.repos["venus_os_integration_patterns"].github_repository.this

# venus_os_ci_toolkit
terraform state mv github_repository.venus_os_ci_toolkit module.repos["venus_os_ci_toolkit"].github_repository.this

# setup_helper
terraform state mv github_repository.setup_helper module.repos["setup_helper"].github_repository.this

# github_org
terraform state mv github_repository.github_org module.repos["github_org"].github_repository.this

# dbus_virtual_battery (also: virtual_battery → dbus_virtual_battery from prior refactor)
terraform state mv github_repository.virtual_battery module.repos["dbus_virtual_battery"].github_repository.this

# dbus_pump
terraform state mv github_repository.dbus_pump module.repos["dbus_pump"].github_repository.this

# dbus_evcharger
terraform state mv github_repository.dbus_evcharger module.repos["dbus_evcharger"].github_repository.this

# dbus_ev
terraform state mv github_repository.dbus_ev module.repos["dbus_ev"].github_repository.this

# ── github_repository_vulnerability_alerts → module ───────────────────────────
# Each: count=1 so always index [0]
for repo in inverter_control inverter_dashboard inverter_dashboard_go inverter_desktop \
            inverter_dashboard_vue dbus_mqtt_battery dbus_tasmota_pv dbus_emporia_vue \
            esphome_jbd_bms_mqtt venus_os_observability inverter_monitoring \
            integration_tests dbus_event_log dbus_esphome_grid_sensor \
            venus_os_integration_patterns venus_os_ci_toolkit setup_helper \
            dbus_virtual_battery dbus_pump dbus_evcharger dbus_ev; do
  terraform state mv \
    "github_repository_vulnerability_alerts.${repo}" \
    "module.repos[\"${repo}\"].github_repository_vulnerability_alerts.this[0]"
done

# ── github_repository_dependabot_security_updates → module ───────────────────
# Only repos where dependabot is enabled (dependabot_security_updates = true in local.repositories):
for repo in inverter_control inverter_dashboard inverter_dashboard_go inverter_desktop \
            inverter_dashboard_vue dbus_mqtt_battery dbus_tasmota_pv dbus_emporia_vue \
            esphome_jbd_bms_mqtt venus_os_observability inverter_monitoring \
            integration_tests dbus_event_log dbus_esphome_grid_sensor \
            venus_os_integration_patterns venus_os_ci_toolkit setup_helper \
            dbus_pump dbus_evcharger dbus_ev; do
  terraform state mv \
    "github_repository_dependabot_security_updates.${repo}" \
    "module.repos[\"${repo}\"].github_repository_dependabot_security_updates.this[0]"
done
# Note: dbus_virtual_battery, github_org have dependabot=false — skip those.

# ── github_repository_ruleset key rename ──────────────────────────────────────
terraform state mv \
  "github_repository_ruleset.default_remaining[\"virtual-battery\"]" \
  "github_repository_ruleset.default_remaining[\"dbus-virtual-battery\"]"
```

## Phase 3: Verify plan is move-only

After all `state mv` commands, run:

```bash
terraform plan
```

Expected output: **0 to add, 0 to destroy, only `~` (in-place updates) or
`<=` (no-op) for existing resources. If any `+` appears for a repo that
already exists on GitHub, a `state mv` was missed.

## Phase 4: Apply

```bash
terraform apply
```
