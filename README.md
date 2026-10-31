# Victron Venus GitHub Infrastructure as Code

[![CI](https://github.com/4alvit/terraform-github-victron/actions/workflows/ci.yml/badge.svg)](https://github.com/4alvit/terraform-github-victron/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub last commit](https://img.shields.io/github/last-commit/4alvit/terraform-github-victron)](https://github.com/4alvit/terraform-github-victron/commits/main)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/4alvit/terraform-github-victron/graphs/commit-activity)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.15.7-blue.svg)](https://www.terraform.io/)

This Terraform configuration manages the entire GitHub infrastructure for the victron-venus organization.

<!-- ci-release-process:start -->
## CI and deployment

See [CI and deployment workflow](docs/release-workflow.md) for required checks and local commands. This repository uses validation-only policy; application release channels do not apply.
<!-- ci-release-process:end -->

## What's Managed

- **Organization settings** (security defaults, permissions)
- **Repositories** with full configuration (subset listed below — see `main.tf` for all):
  - `inverter-control`
  - `inverter-dashboard`
  - `dbus-mqtt-battery`
  - `dbus-tasmota-pv`
  - `esphome-jbd-bms-mqtt`
- **Repository settings**: topics, visibility, merge options
- **Branch protection rules**: required status checks
- **Security features**: Dependabot, secret scanning, vulnerability alerts
- **GitHub Actions secrets**

## Prerequisites

1. **Terraform** >= 1.15.7 for the existing HCP configuration (CI checks 1.16.6), or the verified OpenTofu 1.13.1 [independent local deployment profile](docs/SECURE_PROVIDER.md#complete-local-deployment-profile).
2. **GitHub Personal Access Token** with scopes:
   - `admin:org` (organization settings)
   - `repo` (full repository access)
   - `workflow` (GitHub Actions workflows)
   - `delete_repo` (if you want to destroy resources)

## Usage

For new independent deployments, use the [complete secure-provider profile](docs/SECURE_PROVIDER.md#complete-local-deployment-profile). It verifies the OpenTofu engine and disclosed provider derivative and prevents fallback to the older official binary. The existing HCP workspace below retains that older provider and has not been migrated or qualified by the local-profile work.

### Option A: Existing HCP Terraform deployment

The canonical backend is HCP Terraform organization `alvit-infrastructure`,
workspace `github-infrastructure`. It manages GitHub organization
`victron-venus`; changing the HCP organization does not change the GitHub owner.
The transfer completed on 2026-10-14. After verifying the state copy and full
destination plan, the previous workspace was deleted without destroying GitHub
resources; see the
[migration record](STATE_MIGRATION.md#hcp-organization-transfer-2026-10-14).

```bash
cd terraform-github-victron

# Print the connection checklist (no backend changes)
./setup-cloud.sh
```

Connect to the existing workspace:

1. Confirm access to the existing
   [canonical workspace](https://app.terraform.io/app/alvit-infrastructure/workspaces/github-infrastructure)
   and confirm its state, variables and execution settings are available.
2. Use an authorized destination token from a private credential store through
   `TF_TOKEN_app_terraform_io`, scoped to the command or current operator session.
   On an operator machine with the existing `~/.local/bin/terraform-4alvit`
   wrapper configured for the destination account, use that wrapper for the
   `init` and `plan` commands below instead of bare `terraform`.
   Verify the effective HCP identity with the `/account/details` API and its
   access to the destination organization; the HCP username may have changed
   and does not need to match the GitHub owner. Do not overwrite the default
   saved CLI credentials or paste tokens into chat, logs or this repository.
3. Initialize a clean checkout: `terraform init`. Initialization is not the state
   migration procedure and must not create an empty replacement workspace.
4. Confirm the existing sensitive inputs are available: `github_token`,
   `billing_email`, `existing_webhook_url` and `existing_webhook_secret`, together
   with all other workspace and variable-set inputs.
5. Run `terraform plan` and inspect the real state-aware result before any
   apply. Do not re-import existing infrastructure or resume management from
   the previous workspace. Existing drift is recorded in the migration notes.

### Option B: New independent local deployment

Follow the [complete local deployment instructions](docs/SECURE_PROVIDER.md#complete-local-deployment-profile) using a new private workspace, a separate owned target inventory and the verified wrapper for every init, plan and apply command. Those instructions include the OpenTofu compatibility changes and private variable inputs. The disposable [schema validator](docs/SECURE_PROVIDER.md#validate-without-touching-production-state) can check compatibility without contacting or changing existing resources.

Do not detach the existing HCP checkout and apply an empty local state against its resources. Moving an established deployment requires a separately reviewed state migration: preserve a private backup, coordinate an exclusive writer, verify resource addresses and credentials, and review the complete state-aware plan before any apply. A state download or deletion of backend cache alone does not establish a safe migration. The existing migration history is in [STATE_MIGRATION.md](STATE_MIGRATION.md).

Never commit credentials, private variable files, plan files or state files.

Every managed repository enables `delete_branch_on_merge = true`, including the
adopted website. The shared repository module rejects `false` and `null`; its
mocked contract tests run in `scripts/test-release-governance.sh`. GitHub deletes
eligible pull-request head branches after merge, subject to branch protection
and rulesets. This does not remove local branches, worktrees or unmerged work.
Source changes alone do not update GitHub: use the canonical workspace and verify
the live setting after apply. An imported `false` value left in source would
otherwise revert a manual GitHub correction on the next apply.

## Import Existing Resources

The canonical workspace already tracks the existing resources. Do not re-import
them. Current adoption records are in [adopted-imports.tf](adopted-imports.tf);
[STATE_MIGRATION.md](STATE_MIGRATION.md) records completed state migrations.

For a new independent deployment that adopts resources you own, use the actual
module and resource addresses in that deployment's current configuration.
Review the import IDs against its existing state and inspect a full state-aware
plan before applying. Historical flat resource addresses and migration commands
are not an import checklist for the canonical workspace.

## Completed Features

- ✅ **Branch Rulesets & Permissions**: Rulesets verified and configured
- ✅ **Secret Scanning & Push Protection**: Enabled `secret_scanning` and `secret_scanning_push_protection` across all 12 organization repositories in `main.tf`
- ✅ **Terraform CI Validation**: GitHub Actions workflow for `terraform fmt -check` and `tflint` on pull requests

## Administrator merge override

The additive `Release standard - required CI gate` keeps strict CI requirements
for normal merges. Repository administrators (role ID 5) can explicitly bypass
this gate when merging a pull request. That existing role-based exception stays
limited to pull requests. Organization owners separately have permanent branch
bypass through the shared owner policy. Archived repositories retain their
existing rules without a new bypass grant.

Other review requirements and the release-environment approval policy retain
their existing settings. Immutable version tags remain protected.

## Adopted infrastructure

`adopted-infrastructure.tf` and `adopted-imports.tf` record the existing archived
`venus-os-governance` repository, the organization website, two GitHub Pages
sites and environments, their four deployment branch policies, and the active
monitoring webhook. The archived default branch ruleset is managed with the
other default rulesets. The website now uses `main` as both its managed default
branch and its existing Pages source. The earlier `feature/redirect` Git
history remains intact; changing the default branch does not rewrite it or
change the Pages URL. Other imported settings remain unchanged, and archived
code is not unarchived.
The topic lists in `main.tf` also preserve the values observed on GitHub.

The five disabled standalone Copilot rulesets were retired to reduce the HCP
managed-resource count. Active review, CI and release rules remain managed.
The five explicit grants to organization owner `4alvit` are no longer managed:
a `removed` block with `destroy = false` preserves the existing grants while
removing their state bindings. See [the cleanup migration](STATE_MIGRATION.md#hcp-resource-cleanup-2026-10-14).

The GitHub provider omits merge settings when reading archived repositories and
skips API updates while they remain archived. The initial governance import
therefore hydrates those state fields from the explicitly verified settings.

The active `inverter-monitoring` webhook retains its existing receiver URL,
`push` and `workflow_run` events, JSON payloads and TLS certificate verification.
Its original HMAC secret is verified against the live receiver and supplied only
through the sensitive HCP inputs `existing_webhook_url` and
`existing_webhook_secret`. GitHub returns a masked secret during import; the
initial plan replaces that mask with the verified original receiver secret.
No secret value is committed or newly generated.

Two inactive retired control/dashboard webhooks and write-only Actions secrets
remain externally managed and untouched. The archived `dbus-evcharger` repository
and its settings are also externally managed after consolidation into `dbus-ev`;
see [the retirement migration](STATE_MIGRATION.md#retired-dbus-evcharger-2026-09-22).
The inventory covers repository settings, active rulesets, environments and
their branch policies, both Pages sites, and the active webhook.
There are no additional deploy keys, teams or organization webhooks to import.
No new lifecycle ignore rules hide differences.

## File Structure

```
terraform-github-victron/
├── main.tf              # Main configuration
├── variables.tf         # Variable definitions
├── outputs.tf           # Output values
├── terraform.tfvars     # Your values (gitignored)
├── terraform.tfvars.example
├── .gitignore
└── README.md
```

## Security Notes

- `terraform.tfvars` is gitignored - never commit secrets
- Use environment variables for CI/CD:
  ```bash
  export TF_VAR_github_token="ghp_xxx"
  ```
- Consider using Terraform Cloud or Vault for secret management

## Limitations

- **Organization creation** must be done manually (Terraform can only manage existing orgs)
- **Repository content** (code, commits) is not managed by Terraform
- **Dependabot config files** (`.github/dependabot.yml`) are in the repos, not Terraform
- **GitHub Actions workflows** are stored in repos, not managed here

## Destroying Infrastructure

⚠️ **Warning**: This will delete all repositories!

```bash
terraform destroy
```

## Related Projects

This project is part of the Victron Venus OS integration suite:

| Project | Description |
|---------|-------------|
| [inverter-control](https://github.com/victron-venus/inverter-control) | Advanced ESS external control system with grid-zero targeting |
| [inverter-dashboard](https://github.com/victron-venus/inverter-dashboard) | Real-time web dashboard (Python/FastAPI) via MQTT |
| [inverter-dashboard-go](https://github.com/victron-venus/inverter-dashboard-go) | High-performance Go rewrite of the web dashboard |
| [inverter-desktop](https://github.com/victron-venus/inverter-desktop) | Native desktop application (Rust/Tauri) for system monitoring |
| [dbus-mqtt-battery](https://github.com/victron-venus/dbus-mqtt-battery) | MQTT to D-Bus bridge for JBD BMS battery integration |
| [dbus-tasmota-pv](https://github.com/victron-venus/dbus-tasmota-pv) | Tasmota smart plug integration as a PV inverter on D-Bus |
| [esphome-jbd-bms-mqtt](https://github.com/victron-venus/esphome-jbd-bms-mqtt) | ESP32 Bluetooth monitor for JBD BMS batteries |
| [inverter-monitoring](https://github.com/victron-venus/inverter-monitoring) | TIG (Telegraf, InfluxDB, Grafana) monitoring stack |
| **terraform-github-victron** (this) | [https://github.com/4alvit/terraform-github-victron](https://github.com/4alvit/terraform-github-victron) |

## License

MIT License

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature-name`)
3. Commit your changes
4. Push to the branch (`git push origin feature-name`)
5. Create a Pull Request

## Support

For issues specific to:
- **Terraform**: See [Terraform documentation](https://www.terraform.io/docs)
- **GitHub API**: See [GitHub REST API documentation](https://docs.github.com/en/rest)
- **This Terrafor configuration**: Open an issue in this repository

**Note:** This is a community project and is not affiliated with Victron Energy.

## Contributions and public security

See [CONTRIBUTING.md](CONTRIBUTING.md) for bug reports, proposed changes and tests,
[SECURITY.md](SECURITY.md) for private vulnerability reports, and
[public security policy](docs/public-security.md) for review requirements,
secret protection and rollout/state ownership. OpenSSF readiness is assessed
for this infrastructure repository separately from the projects it manages.

## Maintenance and verified operation

See the [supported TLS profile](docs/TLS_PROFILE.md), [assessment evidence](docs/openssf-evidence.md), [governance](GOVERNANCE.md), [Code of Conduct](CODE_OF_CONDUCT.md), and [one-year roadmap](ROADMAP.md).

[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/15573/badge)](https://www.bestpractices.dev/projects/15573)

The [disclosed secure-provider profile](docs/SECURE_PROVIDER.md) builds a reviewed patched GitHub provider, validates an isolated source copy and supports a guarded independent local deployment with OpenTofu; production locks and state are not automatically changed. The [engine advisory assessment](docs/OPENTOFU_ADVISORIES.md) is dated and scoped.

## Permanent owner authority

Organization owners have a [permanent branch bypass](docs/public-security.md#permanent-owner-bypass), including direct updates and history repair. Configured review and CI requirements remain for actors without an applicable bypass, and immutable tag rules are unchanged. Terraform must be applied to the canonical state and live rules verified before relying on it.
