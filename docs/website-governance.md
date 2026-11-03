# Organization website review policy

The public organization website is already managed by `github_repository.website`.
Its existing default-branch ruleset is
`github_repository_ruleset.release_quality_gate["victron-venus.github.io"]`,
[ruleset 23126334](https://github.com/victron-venus/victron-venus.github.io/rules/23126334).
Previously it required a successful CI gate but did not require a pull request.
The reviewed change adds one current approving review, stale-review dismissal,
last-push approval and resolved review discussions to this same policy.

The existing strict `CI gate` from GitHub Actions (app 15368), deletion and
non-fast-forward protections remain unchanged. Organization owners keep their
permanent exception, and repository administrators retain their existing
pull-request-only exception. Ordinary write access cannot bypass review.
Private or archived repositories do not receive the new review requirement.

After applying the exact reviewed full plan, verify the same ruleset ID and
Terraform address, all existing checks and exceptions, and the new review rule.
Successful source tests or a plan alone do not establish live enforcement.
No owner-wide policy reconciliation is needed.

## Extra approval after Terraform

The pinned provider does not preserve
`require_extra_approval_for_unattributed_changes`; GitHub can default it to true.
The intended value is false while the current review and CI remain required.
The following read-only inspector is scoped to the exact repository, ruleset
name, source and ID. To correct only that flag after an approved apply, change
`python3 -` to `python3 - --apply`. It saves the before-body, rejects concurrent
changes and verifies every other writable field is unchanged. An existing
receipt requires inspection, not deletion and an automatic retry.

```bash
python3 - <<'PY'
import copy
import json
from pathlib import Path
import subprocess
import sys

if not __debug__:
    raise RuntimeError("Run without Python optimization; guards must be enabled")

repo = "victron-venus/victron-venus.github.io"
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
           if rule["name"] == "Release standard - required CI gate"
           and rule["source_type"] == "Repository" and rule["source"] == repo]
assert len(matches) == 1, "Expected one Website-owned ruleset"
assert matches[0]["id"] == 23126334, "Ruleset identity changed; verify Terraform state and the approved plan"
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
    folder = Path.home() / ".codex/artifacts/website-review-policy"
    folder.mkdir(mode=0o700, parents=True, exist_ok=True)
    receipt = folder / f"ruleset-{original['id']}-before.json"
    with receipt.open("x") as stream:
        receipt.chmod(0o600)
        json.dump(original, stream, indent=2)
    assert writable(api(endpoint)) == before, "Ruleset changed; inspect again"
    api(endpoint, after)
    assert writable(api(endpoint)) == after, "Readback differs; inspect the receipt"
    print("Verified Website-only flag correction")
PY
```

The before-body receipt contains only nonsecret policy metadata. If a future
approved replacement changes the ruleset ID, reconcile the state and reviewed
plan before changing the identity guard above.
