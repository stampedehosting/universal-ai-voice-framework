#!/bin/bash
# Deploy to VPS using Terraform

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

PROVIDER="aws"
REGION="us-west-2"
PROJECT=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --provider)
      PROVIDER="$2"
      shift 2
      ;;
    --region)
      REGION="$2"
      shift 2
      ;;
    --project)
      PROJECT="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

if [ -z "$PROJECT" ]; then
  echo -e "${RED}Error: --project is required${NC}"
  exit 1
fi

echo -e "${GREEN}Deploying VPS for: $PROJECT${NC}"
echo -e "${YELLOW}Provider: $PROVIDER${NC}"
echo -e "${YELLOW}Region: $REGION${NC}"

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
  echo -e "${RED}Error: Terraform is not installed${NC}"
  echo -e "${YELLOW}Install with: brew install terraform (macOS) or apt install terraform (Linux)${NC}"
  exit 1
fi

# Navigate to Terraform directory
TERRAFORM_DIR="$(dirname "$0")/../provisioning/terraform/$PROVIDER"
if [ ! -d "$TERRAFORM_DIR" ]; then
  echo -e "${RED}Error: Terraform configuration for $PROVIDER not found${NC}"
  exit 1
fi

cd "$TERRAFORM_DIR"

# Initialize Terraform
echo -e "${YELLOW}Initializing Terraform...${NC}"
terraform init -upgrade

# Load API keys
VAULT_FILE="$(dirname "$0")/../config/api-keys.vault.json"
if [ -f "$VAULT_FILE" ]; then
  export TF_VAR_project_name="$PROJECT"
  
  # Extract AWS credentials if provider is aws
  if [ "$PROVIDER" = "aws" ]; then
    export TF_VAR_aws_access_key_id=$(cat "$VAULT_FILE" | grep -A 5 '"provisioning"' | grep '"access_key_id"' | sed 's/.*: "\(.*\)".*/\1/')
    export TF_VAR_aws_secret_access_key=$(cat "$VAULT_FILE" | grep -A 5 '"provisioning"' | grep '"secret_access_key"' | sed 's/.*: "\(.*\)".*/\1/')
    export TF_VAR_aws_region="$REGION"
  fi
fi

# Plan deployment
echo -e "${YELLOW}Planning deployment...${NC}"
terraform plan

# Apply deployment
echo -e "${YELLOW}Deploying infrastructure...${NC}"
terraform apply -auto-approve

# Get outputs
VPS_IP=$(terraform output -raw vps_ip 2>/dev/null || echo "")
if [ -n "$VPS_IP" ]; then
  echo -e "${GREEN}✅ VPS deployed at: $VPS_IP${NC}"
  
  # Save VPS IP for later use
  mkdir -p "/tmp/projects/$PROJECT"
  echo "$VPS_IP" > "/tmp/projects/$PROJECT/vps_ip.txt"
else
  echo -e "${YELLOW}⚠️  Could not retrieve VPS IP${NC}"
fi

echo -e "${GREEN}✅ VPS deployment complete${NC}"
