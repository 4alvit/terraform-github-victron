# Public software security policy

## Emergency owner merges

The owner policy approved on 2026-10-27 permits organization owners (`OrganizationAdmin`, with no actor ID)
to bypass branch requirements **only while merging a pull request**. The shared
`owner_emergency_merge_actor` in `admin-merge-policy.tf` is attached to each
managed branch ruleset, including separate review and CI gates. A grant on only
one ruleset cannot override another applicable rule. Existing unrelated actor
exceptions are preserved; this change does not grant automation new privileges.

Ordinary merges retain their existing reviews, CI, signatures and resolved-thread
requirements. Use the exception deliberately for a necessary recovery, record the
reason and available validation in the PR, and follow up on skipped checks. The
new grant cannot authorize a direct push, force push, branch deletion or tag
rewrite. Immutable release tags and deployment-environment approvals are unchanged.
Archived repositories remain read-only; existing archived release gates receive
no new actor. Repositories without enforced protection need no bypass grant.

Apply only a reviewed plan against the canonical existing HCP state, then read
back every applicable repository and inherited organization ruleset. An existing
classic branch protection can still prohibit bypass; it needs its own reviewed
state-managed update. Reconcile the unsupported extra Copilot approval field as
described below, preserving the actor list. A merge of this source is not proof
that HCP or GitHub has been updated.

OpenSSF Best Practices and OpenSSF Scorecard are separate assessments. This
exception is an explicit governance tradeoff: do not claim maximum branch
protection or universal two-person review. Reassess the actual badge criteria
and published evidence after any use that skips independent review. The
presence of a badge does not approve an emergency merge.

`public-security.tf` lists the public repositories reviewed for this rollout.
Live metadata excludes private and archived repositories from new protections.
Existing public review rules require one approving review and resolution of
review threads. Existing bypasses and stale-review settings are preserved by
default. Additional enforcement requires an explicit repository entry in
`public_security_enforcement_repositories`: it removes legacy administrator/automation
bypasses while retaining the owner emergency exception, dismisses stale approvals and creates missing review rules without
replacing status checks or immutable-tag rules. Private and archived repositories
remain excluded even when listed. The owner emergency exception applies to
`inverter-control` as well. Adding a repository to the inventory does not enable
additional review enforcement.

Secret scanning and push protection are enabled on the audited public repository
resources managed by this state. Private vulnerability reporting was enabled
separately through GitHub's repository API; the pinned Terraform provider does
not expose that setting. Verify it under repository security settings during
onboarding. Do not put a credential in a commit to test push protection.

## Rollout and state ownership

Merge the application repair PRs after their required checks succeed, then
reconcile this desired configuration with the canonical state. Do not perform a
fleet-wide apply from an empty or unrelated state. If a rule was created through
the API, import its actual repository/ruleset identity at the declared address
before applying; do not create a duplicate rule. For out-of-band setting changes,
refresh and inspect the plan to verify the source preserves them.

One current approval from a reviewer with Write access satisfies the review
count. Automation may provide that approval; it does not replace the required CI
checks or resolution of review threads. Keep the count at one when reconciling
Terraform with GitHub so a later apply cannot restore a two-review requirement.

## Extra Copilot approval after Terraform

GitHub's `require_extra_approval_for_unattributed_changes` setting must be
`false`: otherwise an unattributed Copilot PR needs an extra approval even when
the configured count is one. The pinned GitHub provider does not expose this
field, and sending a ruleset without it restores GitHub's default `true`.

After a ruleset apply or creation, run the shared
[review-policy reconciliation script](https://github.com/4alvit/terraform-github-4alvit/blob/main/scripts/reconcile-review-policy.py)
with `--owner OWNER` to inspect that owner's rules. Use `--apply --backup-dir DIR`
to save the current bodies, change only review counts above one and the extra
approval flag, and verify that all other protections remain intact. Choose a new
local backup directory for each application. Rules without required approvals
keep their zero count; archived repositories stay read-only and are reported.
This step is required until the provider supports the
extra-approval field; a Terraform plan alone cannot validate it.

## Trust boundaries

Terraform credentials can change repository governance; store them in the
canonical workspace's secret variables with the narrow required scope. Source
reviews must consider changed repository sets, ruleset bypasses, workflow token
permissions, release gates and remote object ownership. Validation runs use no
production state or credentials. Provider schemas and mock tests establish
configuration behavior, not the correctness of a future live apply.

## OpenSSF evidence and remaining assessment

Public Git history, the MIT license, README interfaces, contribution policy,
private reporting instructions and executable mock tests provide auditable
inputs for an OpenSSF Best Practices assessment. The new tests cover current
review requirements and exclusion of private/archived repositories. Required
CI results and actual live settings must be checked after merge.

No OpenSSF award is claimed by this document. Maintainer knowledge, external
report-response history, release-note applicability, full static-analysis scope
and all remaining mandatory criteria need individual verification. A repository
is not certified because its managed applications are certified or vice versa.
