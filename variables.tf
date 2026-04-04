variable "github_token" {
  description = "GitHub Personal Access Token with admin:org, repo, and workflow scopes"
  type        = string
  sensitive   = true
}

variable "github_organization" {
  description = "GitHub organization name"
  type        = string
  default     = "victron-venus"
}

variable "billing_email" {
  description = "Organization billing email"
  type        = string
  sensitive   = true
}

variable "ghcr_token" {
  description = "GitHub Container Registry token for Actions"
  type        = string
  sensitive   = true
  default     = ""
}
