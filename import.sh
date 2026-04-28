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
terraform import github_repository.dbus_mqtt_battery dbus-mqtt-battery || true
terraform import github_repository.dbus_tasmota_pv dbus-tasmota-pv || true
terraform import github_repository.esphome_jbd_bms_mqtt esphome-jbd-bms-mqtt || true

# Branch protection rules
echo "Importing branch protection rules..."
terraform import github_branch_protection.inverter_control_main inverter-control:main || true
terraform import github_branch_protection.inverter_dashboard_main inverter-dashboard:main || true
terraform import github_branch_protection.dbus_mqtt_battery_main dbus-mqtt-battery:main || true
terraform import github_branch_protection.dbus_tasmota_pv_main dbus-tasmota-pv:main || true

echo ""
echo "=== Import complete ==="
echo "Run 'terraform plan' to see if any drift exists"
