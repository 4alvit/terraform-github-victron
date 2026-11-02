# Ethernet review policy verification

The existing repository `victron-venus/esphome-emporia-vue2-ethernet` is managed
by `module.repos["esphome_emporia_vue2_ethernet"]`. Its separate branch policy is
`github_repository_ruleset.emporia_vue2_governance[0]`, created as
[ruleset 26392056](https://github.com/victron-venus/esphome-emporia-vue2-ethernet/rules/26392056).
The reviewed full Terraform plan created only this policy; it did not recreate
the repository or alter its Actions permissions.

After each relevant apply, verify that this same Terraform address still owns
the expected ruleset ID, the default branch is protected, one current approval
is required, and these checks remain mandatory:

- `Documentation and examples` from GitHub Actions (app 15368).
- `ESPHome configuration and generation` from GitHub Actions (app 15368).
- `CodeQL` from the CodeQL app (57789), verified on pull-request evaluation.

Only the existing organization-owner exception may bypass the policy. Private
and archived repositories are excluded from new enforcement. Source code or a
successful plan alone does not demonstrate that live protection is active.

## Extra approval after Terraform

The pinned provider does not preserve
`require_extra_approval_for_unattributed_changes`. GitHub can set it to `true`
after an apply, creating an additional approval requirement. The intended
policy keeps that extra flag `false`; the current approval and all CI checks
remain required.

Run the read-only inspection below. It is limited to the exact repository,
policy name, repository-owned source and existing ruleset ID. If an approved
future replacement changes the ID, reconcile the Terraform state and plan first;
do not simply remove the identity guard. Do not use an owner-wide reconciliation
command for this rollout.

To correct only this flag, change the invocation to `python3 - --apply <<'PY'`.
The command preserves every other writable field, saves the original body
locally, rejects a concurrent change before writing, and checks the result.
If the receipt already exists, inspect the previous result instead of deleting
it to retry automatically.

```bash
python3 - <<'PY'
import copy
import json
from pathlib import Path
import subprocess
import sys

if not __debug__:
    raise RuntimeError("Run without Python optimization; guards must be enabled")

repo = "victron-venus/esphome-emporia-vue2-ethernet"
def api(path, body=None, *, pages=False):
    args = ["gh", "api", path]
    if pages:
        args += ["--paginate", "--slurp"]
    if body is not None:
        args += ["--method", "PUT", "--input", "-"]
    value = json.loads(subprocess.check_output(
        args, input=json.dumps(body) if body is not None else None, text=True))
    return [item for page in value for item in page] if pages else value

def writable(value):
    return {key: value[key] for key in (
        "name", "target", "enforcement", "bypass_actors", "conditions", "rules")}

matches = [rule for rule in api(f"repos/{repo}/rulesets?per_page=100", pages=True)
           if rule["name"] == "Ethernet examples - reviewed and validated changes"
           and rule["source_type"] == "Repository" and rule["source"] == repo]
assert len(matches) == 1, "Expected one Ethernet-owned ruleset"
assert matches[0]["id"] == 26392056, "Ruleset identity changed; verify Terraform state and the approved plan"
endpoint = f"repos/{repo}/rulesets/{matches[0]['id']}"
original = api(endpoint)
before = writable(original)
assert before["target"] == "branch" and before["enforcement"] == "active"
after = copy.deepcopy(before)
reviews = [rule for rule in after["rules"] if rule["type"] == "pull_request"]
assert len(reviews) == 1 and reviews[0]["parameters"]["required_approving_review_count"] == 1
reviews[0]["parameters"]["require_extra_approval_for_unattributed_changes"] = False
print(json.dumps({"endpoint": endpoint, "change_needed": before != after}))
if before != after and sys.argv[1:] == ["--apply"]:
    folder = Path.home() / ".codex/artifacts/ethernet-review-policy"
    folder.mkdir(mode=0o700, parents=True, exist_ok=True)
    receipt = folder / f"ruleset-{original['id']}-before.json"
    with receipt.open("x") as stream:
        receipt.chmod(0o600)
        json.dump(original, stream, indent=2)
    assert writable(api(endpoint)) == before, "Ruleset changed; inspect again"
    api(endpoint, after)
    assert writable(api(endpoint)) == after, "Readback differs; inspect the receipt"
    print("Verified Ethernet-only flag correction")
PY
```

The correction does not change review counts, required checks, another
repository, or organization-level rulesets. The before-body receipt is
nonsecret operational evidence under `~/.codex/artifacts/ethernet-review-policy/`.
