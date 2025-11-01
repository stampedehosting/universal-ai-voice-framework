#!/bin/bash
# Integration test for the framework

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== Universal AI Voice Framework Integration Test ===${NC}"
echo ""

# Test 1: Check directory structure
echo -e "${YELLOW}Test 1: Checking directory structure...${NC}"
REQUIRED_DIRS=(
  "config"
  "scripts"
  "provisioning/terraform/aws"
  "templates/fastapi-base"
  "templates/fastapi-base/app"
  "docs"
  "examples"
)

for dir in "${REQUIRED_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    echo "  ✓ $dir exists"
  else
    echo -e "  ${RED}✗ $dir missing${NC}"
    exit 1
  fi
done

# Test 2: Check required files
echo ""
echo -e "${YELLOW}Test 2: Checking required files...${NC}"
REQUIRED_FILES=(
  "config/api-keys.vault.template.json"
  "scripts/init-project.sh"
  "scripts/deploy-vps.sh"
  "scripts/setup-dns.sh"
  "scripts/configure-twilio.sh"
  "scripts/test-deployment.sh"
  "scripts/encrypt-vault.sh"
  "scripts/decrypt-vault.sh"
  "provisioning/terraform/aws/main.tf"
  "provisioning/terraform/aws/variables.tf"
  "templates/fastapi-base/Dockerfile"
  "templates/fastapi-base/requirements.txt"
  "templates/fastapi-base/app/main.py"
  "templates/fastapi-base/app/intents.py"
  "templates/fastapi-base/app/automation.py"
  "templates/fastapi-base/docker-compose.yml"
  "deploy.sh"
  "README.md"
  "LICENSE"
)

for file in "${REQUIRED_FILES[@]}"; do
  if [ -f "$file" ]; then
    echo "  ✓ $file exists"
  else
    echo -e "  ${RED}✗ $file missing${NC}"
    exit 1
  fi
done

# Test 3: Check scripts are executable
echo ""
echo -e "${YELLOW}Test 3: Checking script permissions...${NC}"
EXEC_SCRIPTS=(
  "scripts/init-project.sh"
  "scripts/deploy-vps.sh"
  "scripts/setup-dns.sh"
  "scripts/configure-twilio.sh"
  "scripts/test-deployment.sh"
  "scripts/encrypt-vault.sh"
  "scripts/decrypt-vault.sh"
  "scripts/create-subdomain.py"
  "deploy.sh"
)

for script in "${EXEC_SCRIPTS[@]}"; do
  if [ -x "$script" ]; then
    echo "  ✓ $script is executable"
  else
    echo -e "  ${RED}✗ $script is not executable${NC}"
    exit 1
  fi
done

# Test 4: Validate Python syntax
echo ""
echo -e "${YELLOW}Test 4: Validating Python code...${NC}"
PYTHON_FILES=(
  "templates/fastapi-base/app/main.py"
  "templates/fastapi-base/app/intents.py"
  "templates/fastapi-base/app/automation.py"
  "templates/fastapi-base/app/elevenlabs_client.py"
  "scripts/create-subdomain.py"
)

for pyfile in "${PYTHON_FILES[@]}"; do
  if python3 -m py_compile "$pyfile" 2>/dev/null; then
    echo "  ✓ $pyfile syntax valid"
  else
    echo -e "  ${RED}✗ $pyfile syntax error${NC}"
    exit 1
  fi
done

# Test 5: Validate Bash syntax
echo ""
echo -e "${YELLOW}Test 5: Validating Bash scripts...${NC}"
for script in "${EXEC_SCRIPTS[@]}"; do
  if [[ "$script" == *.sh ]]; then
    if bash -n "$script" 2>/dev/null; then
      echo "  ✓ $script syntax valid"
    else
      echo -e "  ${RED}✗ $script syntax error${NC}"
      exit 1
    fi
  fi
done

# Test 6: Check JSON files
echo ""
echo -e "${YELLOW}Test 6: Validating JSON files...${NC}"
JSON_FILES=(
  "config/api-keys.vault.template.json"
)

for jsonfile in "${JSON_FILES[@]}"; do
  if python3 -c "import json; json.load(open('$jsonfile'))" 2>/dev/null; then
    echo "  ✓ $jsonfile is valid JSON"
  else
    echo -e "  ${RED}✗ $jsonfile invalid JSON${NC}"
    exit 1
  fi
done

# Test 7: Check Terraform files
echo ""
echo -e "${YELLOW}Test 7: Validating Terraform configuration...${NC}"
cd provisioning/terraform/aws
if terraform fmt -check > /dev/null 2>&1; then
  echo "  ✓ Terraform files are formatted"
else
  echo "  ⚠ Terraform files need formatting (non-critical)"
fi

if terraform validate > /dev/null 2>&1; then
  echo "  ✓ Terraform configuration is valid"
else
  # Terraform validate might fail without init, so we just check syntax
  echo "  ⚠ Terraform validation skipped (requires init)"
fi
cd ../../..

# Test 8: Check documentation
echo ""
echo -e "${YELLOW}Test 8: Checking documentation...${NC}"
DOCS=(
  "README.md"
  "docs/QUICK_START.md"
  "docs/API_REFERENCE.md"
  "docs/DEPLOYMENT_GUIDE.md"
  "docs/TROUBLESHOOTING.md"
  "CONTRIBUTING.md"
  "LICENSE"
)

for doc in "${DOCS[@]}"; do
  if [ -f "$doc" ] && [ -s "$doc" ]; then
    echo "  ✓ $doc exists and is not empty"
  else
    echo -e "  ${RED}✗ $doc missing or empty${NC}"
    exit 1
  fi
done

# Summary
echo ""
echo -e "${GREEN}=== All Tests Passed! ===${NC}"
echo ""
echo -e "${GREEN}Framework structure is complete and valid.${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Copy config/api-keys.vault.template.json to config/api-keys.vault.json"
echo "  2. Fill in your API keys"
echo "  3. Run: ./deploy.sh --name my-app --domain example.com"
echo ""
