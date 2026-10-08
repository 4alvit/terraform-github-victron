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

# Retained input for existing workspace compatibility; it does not grant access or create resources.
# tflint-ignore: terraform_unused_declarations
variable "billing_email" {
  description = "Organization billing email"
  type        = string
  sensitive   = true
}

# Retained input for existing workspace compatibility; it does not grant access or create resources.
# tflint-ignore: terraform_unused_declarations
variable "ghcr_token" {
  description = "GitHub Container Registry token for Actions"
  type        = string
  sensitive   = true
  default     = ""
}
