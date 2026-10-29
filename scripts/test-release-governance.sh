#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
temporary=$(mktemp -d "${TMPDIR:-/tmp}/release-governance-test.XXXXXX")
trap 'rm -rf "$temporary"' EXIT
mkdir -p "$temporary/tests" "$temporary/provider-cache"
touch "$temporary/empty.tfrc"
cp admin-merge-policy.tf "$temporary/"
cp public-security.tf release-standards.tf adopted-infrastructure.tf tests/release-governance/main.tf "$temporary/"
cp tests/release-governance.tftest.hcl tests/adopted-infrastructure.tftest.hcl "$temporary/tests/"
if [[ -f .terraform.lock.hcl ]]; then
  cp .terraform.lock.hcl "$temporary/"
fi

# The test copy has no cloud/backend configuration. Drop credentials and ambient
# Terraform arguments, and use mock-provider plan tests with no live API calls.
test_terraform() {
  env -i PATH="$PATH" HOME="$temporary" TF_IN_AUTOMATION=1 TF_INPUT=0 \
    TF_CLI_CONFIG_FILE="$temporary/empty.tfrc" TF_PLUGIN_CACHE_DIR="$temporary/provider-cache" \
    terraform -chdir="$temporary" "$@"
}
test_terraform init -backend=false -input=false -no-color
test_terraform test -no-color

# Exercise the real shared repository module without a backend or live provider.
module_temporary="$temporary/repository-module"
mkdir -p "$module_temporary/tests"
cp modules/github_repo/*.tf "$module_temporary/"
cp .terraform.lock.hcl "$module_temporary/"
cp tests/branch-cleanup-module.tftest.hcl "$module_temporary/tests/"
env -i PATH="$PATH" HOME="$temporary" TF_IN_AUTOMATION=1 TF_INPUT=0 \
  TF_CLI_CONFIG_FILE="$temporary/empty.tfrc" TF_PLUGIN_CACHE_DIR="$temporary/provider-cache" \
  terraform -chdir="$module_temporary" init -backend=false -input=false -lockfile=readonly -no-color
env -i PATH="$PATH" HOME="$temporary" TF_IN_AUTOMATION=1 TF_INPUT=0 \
  TF_CLI_CONFIG_FILE="$temporary/empty.tfrc" TF_PLUGIN_CACHE_DIR="$temporary/provider-cache" \
  terraform -chdir="$module_temporary" test -no-color
