#!/bin/bash
#
# Import existing GitHub infrastructure into Terraform state
# Run this ONCE after terraform init, before terraform apply
#

set -e

echo "=== Importing existing GitHub resources ==="

# Organization settings
echo "Importing organization settings..."
terraform import github_organization_settings.victron_venus victron-venus || true

# Repositories
echo "Importing repositories..."
terraform import github_repository.inverter_control inverter-control || true
terraform import github_repository.inverter_dashboard inverter-dashboard || true
terraform import github_repository.inverter_dashboard_go inverter-dashboard-go || true
terraform import github_repository.inverter_desktop inverter-desktop || true
terraform import github_repository.dbus_mqtt_battery dbus-mqtt-battery || true
terraform import github_repository.dbus_tasmota_pv dbus-tasmota-pv || true
terraform import github_repository.esphome_jbd_bms_mqtt esphome-jbd-bms-mqtt || true
terraform import github_repository.inverter_monitoring inverter-monitoring || true
terraform import github_repository.integration_tests integration-tests || true
terraform import github_repository.github_org .github || true

# Dependabot
echo "Importing Dependabot security updates..."
terraform import github_repository_dependabot_security_updates.integration_tests victron-venus/integration-tests || true

# Branch protection rules
echo "Importing branch protection rules..."
terraform import 'github_branch_protection.main["inverter_control"]' inverter-control:main || true
terraform import 'github_branch_protection.main["inverter_dashboard"]' inverter-dashboard:main || true
terraform import 'github_branch_protection.main["inverter_dashboard_go"]' inverter-dashboard-go:main || true
terraform import 'github_branch_protection.main["inverter_desktop"]' inverter-desktop:main || true
terraform import 'github_branch_protection.main["dbus_mqtt_battery"]' dbus-mqtt-battery:main || true
terraform import 'github_branch_protection.main["dbus_tasmota_pv"]' dbus-tasmota-pv:main || true
terraform import 'github_branch_protection.main["esphome_jbd_bms_mqtt"]' esphome-jbd-bms-mqtt:main || true
terraform import 'github_branch_protection.main["inverter_monitoring"]' inverter-monitoring:main || true
terraform import 'github_branch_protection.main["integration_tests"]' integration-tests:main || true
terraform import 'github_branch_protection.main["github_org"]' .github:main || true

# Files
terraform import github_repository_file.github_org_install '.github:docs/INSTALL.md:main'
terraform import github_repository_file.github_org_contributing '.github:CONTRIBUTING.md:main'

echo ""
echo "=== Import complete ==="
echo "Run 'terraform plan' to see if any drift exists"
