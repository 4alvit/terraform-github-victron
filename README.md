# Victron Venus GitHub Infrastructure as Code

[![CI](https://github.com/victron-venus/terraform-github/actions/workflows/ci.yml/badge.svg)](https://github.com/victron-venus/terraform-github/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/victron-venus/terraform-github)](https://github.com/victron-venus/terraform-github/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/victron-venus/terraform-github)](https://github.com/victron-venus/terraform-github/network/members)
[![GitHub last commit](https://img.shields.io/github/last-commit/victron-venus/terraform-github)](https://github.com/victron-venus/terraform-github/commits/main)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/victron-venus/terraform-github/graphs/commit-activity)
[![Terraform](https://img.shields.io/badge/Terraform-1.0+-blue.svg)](https://www.terraform.io/)

This Terraform configuration manages the entire GitHub infrastructure for the victron-venus organization.

## What's Managed

- **Organization settings** (security defaults, permissions)
- **Repositories** with full configuration (subset listed below — see `main.tf` for all):
  - `inverter-control`
  - `inverter-dashboard`
  - `inverter-dashboard-go` (Go rewrite / sibling of `inverter-dashboard`)
  - `dbus-mqtt-battery`
  - `dbus-tasmota-pv`
  - `esphome-jbd-bms-mqtt`
- **Repository settings**: topics, visibility, merge options
- **Branch protection rules**: required status checks
- **Security features**: Dependabot, secret scanning, vulnerability alerts
- **GitHub Actions secrets**

## Prerequisites

1. **Terraform** >= 1.0
2. **GitHub Personal Access Token** with scopes:
   - `admin:org` (organization settings)
   - `repo` (full repository access)
   - `workflow` (GitHub Actions workflows)
   - `delete_repo` (if you want to destroy resources)

## Usage

### Option A: Terraform Cloud (Recommended)

State is stored securely in Terraform Cloud (free tier: 500 resources).

```bash
cd terraform-github

# Interactive setup
./setup-cloud.sh
```

Or manually:

1. Create account: https://app.terraform.io/signup/account
2. Create organization: `victron-venus`
3. Login: `terraform login`
4. Initialize: `terraform init` (creates workspace automatically)
5. Add variables in Terraform Cloud UI:
   - `github_token` (sensitive)
   - `billing_email` (sensitive)
6. Import: `./import.sh`
7. Apply: `terraform apply`

### Option B: Local State

Comment out the `cloud {}` block in `main.tf`, then:

```bash
cd terraform-github
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

terraform init
terraform plan
terraform apply
```

## Import Existing Resources

If you already have the infrastructure created manually, import it:

```bash
# Import organization settings
terraform import github_organization_settings.victron_venus victron-venus

# Import repositories
terraform import github_repository.inverter_control inverter-control
terraform import github_repository.inverter_dashboard inverter-dashboard
terraform import github_repository.inverter_dashboard_go inverter-dashboard-go
terraform import github_repository.dbus_mqtt_battery dbus-mqtt-battery
terraform import github_repository.dbus_tasmota_pv dbus-tasmota-pv
terraform import github_repository.esphome_jbd_bms_mqtt esphome-jbd-bms-mqtt

# Import branch protection
terraform import github_branch_protection.inverter_control_main inverter-control:main
terraform import github_branch_protection.inverter_dashboard_main inverter-dashboard:main
terraform import github_branch_protection.dbus_mqtt_battery_main dbus-mqtt-battery:main
terraform import github_branch_protection.dbus_tasmota_pv_main dbus-tasmota-pv:main
```

## File Structure

```
terraform-github/
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

- [inverter-control](https://github.com/victron-venus/inverter-control)
- [inverter-dashboard](https://github.com/victron-venus/inverter-dashboard)
- [inverter-dashboard-go](https://github.com/victron-venus/inverter-dashboard-go)
- [dbus-mqtt-battery](https://github.com/victron-venus/dbus-mqtt-battery)
- [dbus-tasmota-pv](https://github.com/victron-venus/dbus-tasmota-pv)
- [esphome-jbd-bms-mqtt](https://github.com/victron-venus/esphome-jbd-bms-mqtt)

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
