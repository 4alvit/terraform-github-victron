variable "name" {
  description = "Repository name"
  type        = string
}

variable "description" {
  description = "Repository description"
  type        = string
}

variable "visibility" {
  description = "Repository visibility"
  type        = string
  default     = "public"
}

variable "has_issues" {
  description = "Enable issues"
  type        = bool
  default     = true
}

variable "has_projects" {
  description = "Enable projects"
  type        = bool
  default     = true
}

variable "has_wiki" {
  description = "Enable wiki"
  type        = bool
  default     = true
}

variable "has_discussions" {
  description = "Enable discussions"
  type        = bool
  default     = false
}

variable "allow_merge_commit" {
  description = "Allow merge commits"
  type        = bool
  default     = true
}

variable "allow_squash_merge" {
  description = "Allow squash merging"
  type        = bool
  default     = true
}

variable "allow_rebase_merge" {
  description = "Allow rebase merging"
  type        = bool
  default     = true
}

variable "allow_auto_merge" {
  description = "Allow auto-merge"
  type        = bool
  default     = true
}

variable "delete_branch_on_merge" {
  description = "Delete branch on merge"
  type        = bool
  default     = true
}

variable "topics" {
  description = "Repository topics"
  type        = list(string)
  default     = []
}

variable "license_template" {
  description = "License template"
  type        = string
  default     = "mit"
}

variable "vulnerability_alerts" {
  description = "Enable vulnerability alerts"
  type        = bool
  default     = true
}

variable "dependabot_security_updates" {
  description = "Enable Dependabot security updates"
  type        = bool
  default     = false
}

resource "github_repository" "this" {
  name        = var.name
  description = var.description
  visibility  = var.visibility

  has_issues      = var.has_issues
  has_projects    = var.has_projects
  has_wiki        = var.has_wiki
  has_discussions = var.has_discussions

  allow_merge_commit = var.allow_merge_commit
  allow_squash_merge = var.allow_squash_merge
  allow_rebase_merge = var.allow_rebase_merge
  allow_auto_merge   = var.allow_auto_merge

  delete_branch_on_merge = var.delete_branch_on_merge

  topics           = var.topics
  license_template = var.license_template
}

resource "github_repository_vulnerability_alerts" "this" {
  count      = var.vulnerability_alerts ? 1 : 0
  repository = github_repository.this.name
  depends_on = [github_repository.this]
}

resource "github_repository_dependabot_security_updates" "this" {
  count      = var.dependabot_security_updates ? 1 : 0
  repository = github_repository.this.id
  enabled    = true
}

output "name" {
  value = github_repository.this.name
}

output "html_url" {
  value = github_repository.this.html_url
}

output "ssh_clone_url" {
  value = github_repository.this.ssh_clone_url
}

output "id" {
  value = github_repository.this.id
}

output "repository" {
  value = github_repository.this
}
