#!/bin/bash
#
# Setup Terraform Cloud for victron-venus GitHub infrastructure
#

set -e

echo "=============================================="
echo "  Terraform Cloud Setup"
echo "=============================================="
echo ""

# Check if terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "Error: terraform is not installed"
    echo "Install: brew install terraform"
    exit 1
fi

echo "Step 1: Create Terraform Cloud account"
echo "  → Open: https://app.terraform.io/signup/account"
echo ""
read -p "Press Enter when you have created an account..."

echo ""
echo "Step 2: Create organization 'victron-venus'"
echo "  → Open: https://app.terraform.io/app/organizations/new"
echo "  → Organization name: victron-venus"
echo ""
read -p "Press Enter when organization is created..."

echo ""
echo "Step 3: Login to Terraform Cloud"
terraform login

echo ""
echo "Step 4: Initialize Terraform (creates workspace automatically)"
terraform init

echo ""
echo "Step 5: Configure variables in Terraform Cloud"
echo "  → Open: https://app.terraform.io/app/victron-venus/workspaces/github-infrastructure/variables"
echo ""
echo "  Add these variables:"
echo "    - github_token (sensitive) = your GitHub PAT"
echo "    - billing_email (sensitive) = your email"
echo ""
read -p "Press Enter when variables are configured..."

echo ""
echo "Step 6: Import existing resources"
./import.sh

echo ""
echo "Step 7: Verify configuration"
terraform plan

echo ""
echo "=============================================="
echo "  Setup Complete!"
echo "=============================================="
echo ""
echo "Your Terraform state is now stored securely in Terraform Cloud."
echo ""
echo "Workspace URL:"
echo "  https://app.terraform.io/app/victron-venus/workspaces/github-infrastructure"
echo ""
echo "Commands:"
echo "  terraform plan   - Preview changes"
echo "  terraform apply  - Apply changes"
echo "  terraform show   - View current state"
