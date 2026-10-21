# Public retrofit documentation and ESPHome examples. Explicit security opt-in
# in main.tf avoids querying a repository that does not exist during bootstrap.
resource "github_workflow_repository_permissions" "emporia_vue2_ethernet" {
  repository                       = module.repos["esphome_emporia_vue2_ethernet"].name
  default_workflow_permissions     = "read"
  can_approve_pull_request_reviews = false
}
