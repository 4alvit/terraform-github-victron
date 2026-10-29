mock_provider "github" {
  override_during = plan
}

variables {
  name        = "repository-policy-fixture"
  description = "Offline repository policy test"
}

run "cleanup_is_enabled_by_default" {
  command = plan
  assert {
    condition     = github_repository.this.delete_branch_on_merge
    error_message = "The repository module must enable merged-branch cleanup by default."
  }
}

run "cleanup_cannot_be_disabled" {
  command = plan
  variables {
    delete_branch_on_merge = false
  }
  expect_failures = [var.delete_branch_on_merge]
}

run "cleanup_cannot_be_null" {
  command = plan
  variables {
    delete_branch_on_merge = null
  }
  expect_failures = [var.delete_branch_on_merge]
}
