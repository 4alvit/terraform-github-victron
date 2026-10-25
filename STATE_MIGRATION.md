# State Migration Guide

## HCP organization transfer (2026-10-14)

The canonical backend is now `alvit-infrastructure/github-infrastructure`.
The transfer completed on 2026-10-14, with the backend configuration merged in
[PR #68](https://github.com/4alvit/terraform-github-victron/pull/68).
The state copy and full destination plan were verified before cutover.
GitHub ownership remains `victron-venus`. The state IDs, serials and resource
counts below describe that cutover; inspect the current workspace before any
new operation.

- Previous workspace: `victron-venus/github-infrastructure`,
  `ws-qUGm76z3WGdsLsTn`, state `sv-jqQ4dXqkhYwRrb92`.
- Canonical workspace: `alvit-infrastructure/github-infrastructure`,
  `ws-4QbDi4nRwJGphqvb`, with state `sv-2zCA58eZEfSQdN2N` at cutover.
- The copy preserved identical raw state, lineage and serial `160`, with
  **221 billable managed resources and 272 state entries**. All four workspace
  inputs and execution settings were copied; CLI state listing matched all
  272 addresses. Resource addresses and GitHub IDs did not change.
- The full destination plan, `run-WAr4gnZjpsyzfCNV`
  (`plan-33cqeeoxhHPUrcgj`, configuration `cv-6CDX4dAYQDhgowfv`), matched the
  source baseline `run-RSYji9r3YcfrVXD3` across all compared plan fields.
  Its only proposed resource update was the pre-existing
  `inverter-desktop.homepage_url` drift. No infrastructure apply was performed
  as part of this backend verification; that drift was left for a separate change.

The previous workspace was locked during cutover and deleted after the state,
variables, destination plan and archived source history were verified. This
retired its HCP tracking without destroying any GitHub resources. The final
2026-10-14 audit confirmed that the old workspace was absent and the destination
retained the copied state. The transfer freed **221 billable managed resources**
in HCP organization `victron-venus`, reducing its count from **494 to 273** at
that time. All other workspaces, including the **19 Portainer workspaces and
their states**, were unchanged by the transfer.

Use only the existing canonical workspace. Do not recreate the previous
workspace or manage the same resources from a second state.

Source history was archived privately outside the repository: **160 state
versions and 216 runs**, with verified SHA256 checksums for every archived
file. The archive includes the completed source baseline run. It contains
secrets and must not be committed; retain it for recovery and audit.

Use an authorized destination token from a private credential store through
`TF_TOKEN_app_terraform_io`, scoped to the command or operator session. Where
already configured, `~/.local/bin/terraform-4alvit` selects that account for
Terraform commands. Verify `/account/details` and organization access instead
of requiring a particular username; keep default saved CLI credentials intact.
Never place tokens or state contents in chat, logs or source control.

For recovery, reconcile the latest authoritative state before changing the
backend. Never resume an old source snapshot after the destination has changed
infrastructure. Restore from the private archive only after that reconciliation;
do not re-import the existing resources.

The sections below record earlier operations at the previous workspace. Their
old HCP organization references are historical, not instructions to repeat
those state changes during this transfer.

## HCP resource cleanup (2026-10-14)

The cleanup removes ten managed resources from `victron-venus/github-infrastructure`:

- Delete only the five `github_repository_ruleset.disabled_copilot` instances
  for `dbus-tasmota-pv`, `inverter-control`, `inverter-dashboard`,
  `inverter-desktop`, and `inverter-monitoring`. Their live enforcement was
  verified as `disabled`; active rulesets are unchanged.
- Forget the five `github_repository_collaborator.existing_admin` bindings
  for `dbus-event-log`, `dbus-mqtt-battery`, `dbus-tasmota-pv`,
  `esphome-jbd-bms-mqtt`, and `inverter-control`. The `removed` block explicitly
  sets `destroy = false`, so Terraform must not revoke any grant. The account
  `4alvit` remains an organization owner.

The corresponding import blocks are removed to prevent re-adoption. Preserve a
private state backup and review the saved plan before applying: exactly five
rule deletions and five forget actions, with no other infrastructure changes.
If a full plan contains unrelated drift, reconcile or scope the cleanup before
applying; do not include unrelated updates in this migration. Afterwards verify
that all ten addresses are absent, the five disabled rules are gone, owner
access and active rules remain intact, and a cleanup plan is empty.

All Portainer workspaces and stacks, the archived `venus-os-governance` project,
and existing GitHub Pages and webhook settings remain managed as before.
The empty `victron-venus/ottplay-swop` workspace is a separate HCP cleanup;
the active project backend in organization `open-ott-play` is unrelated.

## Retired `dbus-evcharger` (2026-09-22)

The charger service has moved into `dbus-ev`. The archived `dbus-evcharger`
repository and its existing GitHub settings are preserved, but no longer managed
by this configuration. The repository inventory, default ruleset inventory,
release activation lists and examples exclude it. Do not import it again.

Before the first apply of this removal, forget the following addresses in the
canonical `victron-venus/github-infrastructure` workspace. Terraform 1.15.7 does
not accept instance keys in `removed.from`, so use an explicit state migration
instead of removing the entire shared resource or module. `state rm` only
removes bindings; it does not delete anything on GitHub.

Run from this configuration, with the canonical cloud backend initialized:

```bash
# State contains secrets. Keep this backup private and outside the repository.
umask 077
backup_dir=$(mktemp -d "${TMPDIR:-/tmp}/dbus-evcharger-state.XXXXXX")
terraform state pull > "$backup_dir/before.tfstate"

retired_addresses=(
  'module.repos["dbus_evcharger"]'
  'data.github_repository.release_standard["dbus-evcharger"]'
  'github_repository_ruleset.default_remaining["dbus-evcharger"]'
  'github_repository_ruleset.release_quality_gate["dbus-evcharger"]'
  'github_repository_ruleset.immutable_release_tags["dbus-evcharger"]'
  'github_repository_environment.release_standard["dbus-evcharger/release"]'
  'github_repository_environment_deployment_policy.release_standard["dbus-evcharger/release"]'
  'github_actions_variable.release_publication_enabled["dbus-evcharger"]'
)
terraform state rm -dry-run "${retired_addresses[@]}"
# Review: exactly 10 instances (9 managed resources and 1 data source).
terraform state rm -lock-timeout=60s "${retired_addresses[@]}"
terraform plan
```

The final full plan must not propose recreating or deleting the retired
repository or its settings. Remove it from any external variable overrides too,
if they still list it. After applying output-only changes, a full plan should
report no changes. These one-time state removals are already completed in the
canonical workspace; do not rerun them there.

## Historical module-address migration

This is the historical module-address migration guide. Do not rerun these moves
on the current canonical workspace: verify existing addresses first. The current
manual-infrastructure adoption uses the explicit IDs in `adopted-imports.tf`.
It restores the archived `venus-os-governance` repository and its default ruleset
to management while retaining `archived = true`; only the old enabled security
update resources remain retired with `destroy = false`.

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

# dbus_ev
terraform state mv github_repository.dbus_ev module.repos["dbus_ev"].github_repository.this

# ── github_repository_vulnerability_alerts → module ───────────────────────────
# Each: count=1 so always index [0]
for repo in inverter_control inverter_dashboard inverter_dashboard_go inverter_desktop \
            inverter_dashboard_vue dbus_mqtt_battery dbus_tasmota_pv dbus_emporia_vue \
            esphome_jbd_bms_mqtt venus_os_observability inverter_monitoring \
            integration_tests dbus_event_log dbus_esphome_grid_sensor \
            venus_os_integration_patterns venus_os_ci_toolkit setup_helper \
            dbus_virtual_battery dbus_pump dbus_ev; do
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
            dbus_pump dbus_ev; do
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
