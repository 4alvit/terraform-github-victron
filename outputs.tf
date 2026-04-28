output "repositories" {
  description = "Created repositories"
  value = {
    inverter_control = {
      name     = github_repository.inverter_control.name
      html_url = github_repository.inverter_control.html_url
      ssh_url  = github_repository.inverter_control.ssh_clone_url
    }
    inverter_dashboard = {
      name     = github_repository.inverter_dashboard.name
      html_url = github_repository.inverter_dashboard.html_url
      ssh_url  = github_repository.inverter_dashboard.ssh_clone_url
    }
    inverter_dashboard_go = {
      name     = github_repository.inverter_dashboard_go.name
      html_url = github_repository.inverter_dashboard_go.html_url
      ssh_url  = github_repository.inverter_dashboard_go.ssh_clone_url
    }
    dbus_mqtt_battery = {
      name     = github_repository.dbus_mqtt_battery.name
      html_url = github_repository.dbus_mqtt_battery.html_url
      ssh_url  = github_repository.dbus_mqtt_battery.ssh_clone_url
    }
    dbus_tasmota_pv = {
      name     = github_repository.dbus_tasmota_pv.name
      html_url = github_repository.dbus_tasmota_pv.html_url
      ssh_url  = github_repository.dbus_tasmota_pv.ssh_clone_url
    }
    esphome_jbd_bms_mqtt = {
      name     = github_repository.esphome_jbd_bms_mqtt.name
      html_url = github_repository.esphome_jbd_bms_mqtt.html_url
      ssh_url  = github_repository.esphome_jbd_bms_mqtt.ssh_clone_url
    }
    inverter_monitoring = {
      name     = github_repository.inverter_monitoring.name
      html_url = github_repository.inverter_monitoring.html_url
      ssh_url  = github_repository.inverter_monitoring.ssh_clone_url
    }
  }
}

output "organization_url" {
  description = "Organization URL"
  value       = "https://github.com/${var.github_organization}"
}
