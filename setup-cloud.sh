#!/bin/bash
# Print the HCP Terraform connection checklist without changing backend or state.

set -euo pipefail

cat <<'GUIDE'
HCP Terraform connection checklist

Canonical organization: alvit-infrastructure
Canonical workspace: github-infrastructure
GitHub owner managed by this configuration: victron-venus (unchanged)

The state copy and full destination plan were verified on 2026-10-14.
See STATE_MIGRATION.md for the source history and existing unrelated drift.
This helper only prints instructions; it does not change backend or state.

Before connecting:
  1. Confirm access to alvit-infrastructure. Verify the effective identity via
     /account/details and organization permissions, not a particular username.
  2. Use the existing workspace; do not create an empty replacement.
  3. Confirm the destination contains the expected state and workspace inputs:
       github_token, billing_email, existing_webhook_url, existing_webhook_secret
     Preserve all other variables, variable sets and execution settings as well.
  4. Load an authorized destination token from a private credential store through
     TF_TOKEN_app_terraform_io for the command or current operator session.
     Where already configured for that account, ~/.local/bin/terraform-4alvit
     can select the destination account for the init and plan commands instead.
     Keep default saved CLI credentials intact; never paste tokens into chat,
     logs or source files. Initialize a clean checkout with terraform init.
  5. Inspect terraform plan before any apply. Treat existing drift separately.

Canonical workspace:
  https://app.terraform.io/app/alvit-infrastructure/workspaces/github-infrastructure
Workspace variables:
  https://app.terraform.io/app/alvit-infrastructure/workspaces/github-infrastructure/variables

Do not re-import existing infrastructure or resume the previous workspace.
GUIDE
