output "repositories" {
  description = "Created repositories"
  value = {
    for k, m in module.repos : k => {
      name     = m.name
      html_url = m.html_url
      ssh_url  = m.ssh_clone_url
    }
  }
}

output "organization_url" {
  description = "Organization URL"
  value       = "https://github.com/${var.github_organization}"
}
