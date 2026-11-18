# Documentation

Terraform for the victron-venus GitHub organization: repository settings, the
OpenTofu validation profile and the governance policies applied here.

## Governance

- [Public software security policy](public-security.md) — the owner policy approved on 2026-10-29 and who it permits.
- [Optional GitHub governance](release-governance.md) — the additive `release-standards.tf` opt-in and its empty defaults.
- [Organization website review policy](website-governance.md) — how the public website repository setting is managed.
- [Ethernet review policy verification](ethernet-governance.md) — how `esphome-emporia-vue2-ethernet` is managed here.

## Toolchain profile

- [FLOSS source-validation profile](OPENTOFU.md) — the pinned OpenTofu, provider and Python versions.
- [OpenTofu profile advisory assessment — 2026-10-16](OPENTOFU_ADVISORIES.md) — the exact source behind the pinned build and its advisories.
- [Disclosed secure-provider profile](SECURE_PROVIDER.md) — how the official provider binary was built and what its dependency scan found.
- [Local-execution TLS transport profile](TLS_PROFILE.md) — key policy only, without resolving the provider's dependencies.

## Evidence

- [Quality evidence and limitations](quality.md) — what the configuration and its validation tooling are, and what is checked.
- [OpenSSF evidence](openssf-evidence.md) — the source index behind the assessment.

## CI

- [CI and release operations](release-workflow.md) — `.release-policy.json` and the required status.
- [CI orchestration](CI-ORCHESTRATION.md) — how the quality gate and release pipeline divide the events.
- [CI and release policy](CI_WORKFLOW.md) — the validation-only policy and its events.
