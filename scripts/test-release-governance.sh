#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
temporary=$(mktemp -d "${TMPDIR:-/tmp}/release-governance-test.XXXXXX")
trap 'rm -rf "$temporary"' EXIT
test_root="$temporary/tests/release-governance"
mkdir -p "$test_root/tests" "$temporary/provider-cache"
mkdir -p "$temporary/modules/github_repo"
cp modules/github_repo/*.tf "$temporary/modules/github_repo/"
touch "$temporary/empty.tfrc"
cp admin-merge-policy.tf "$test_root/"
cp public-security.tf release-standards.tf adopted-infrastructure.tf tests/release-governance/main.tf "$test_root/"
cp tests/release-governance.tftest.hcl tests/adopted-infrastructure.tftest.hcl "$test_root/tests/"
if [[ -f .terraform.lock.hcl ]]; then
  cp .terraform.lock.hcl "$test_root/"
fi

# The test copy has no cloud/backend configuration. Drop credentials and ambient
# Terraform arguments, and use mock-provider plan tests with no live API calls.
test_terraform() {
  env -i PATH="$PATH" HOME="$temporary" TF_IN_AUTOMATION=1 TF_INPUT=0 \
    TF_CLI_CONFIG_FILE="$temporary/empty.tfrc" TF_PLUGIN_CACHE_DIR="$temporary/provider-cache" \
    terraform -chdir="$test_root" "$@"
}
test_terraform init -backend=false -input=false -no-color
test_terraform test -no-color

# Exercise the real shared repository module without a backend or live provider.
module_temporary="$temporary/repository-module"
mkdir -p "$module_temporary/tests"
cp modules/github_repo/*.tf "$module_temporary/"
# Reuse the checksums verified by the first init for this runner's platform.
cp "$test_root/.terraform.lock.hcl" "$module_temporary/"
cp tests/branch-cleanup-module.tftest.hcl "$module_temporary/tests/"
env -i PATH="$PATH" HOME="$temporary" TF_IN_AUTOMATION=1 TF_INPUT=0 \
  TF_CLI_CONFIG_FILE="$temporary/empty.tfrc" TF_PLUGIN_CACHE_DIR="$temporary/provider-cache" \
  terraform -chdir="$module_temporary" init -backend=false -input=false -lockfile=readonly -no-color
env -i PATH="$PATH" HOME="$temporary" TF_IN_AUTOMATION=1 TF_INPUT=0 \
  TF_CLI_CONFIG_FILE="$temporary/empty.tfrc" TF_PLUGIN_CACHE_DIR="$temporary/provider-cache" \
  terraform -chdir="$module_temporary" test -no-color
