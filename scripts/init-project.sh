#!/bin/bash
# Initialize a new project from template

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Default values
PROJECT_NAME=""
DOMAIN=""
TEMPLATE="fastapi-base"
AGENTS=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --name)
      PROJECT_NAME="$2"
      shift 2
      ;;
    --domain)
      DOMAIN="$2"
      shift 2
      ;;
    --template)
      TEMPLATE="$2"
      shift 2
      ;;
    --agents)
      AGENTS="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Validate
if [ -z "$PROJECT_NAME" ] || [ -z "$DOMAIN" ]; then
  echo "Error: --name and --domain are required"
  exit 1
fi

echo -e "${GREEN}Initializing project: $PROJECT_NAME${NC}"

# Create project directory
PROJECT_DIR="/tmp/projects/$PROJECT_NAME"
mkdir -p "$PROJECT_DIR"

# Copy template
TEMPLATE_DIR="$(dirname "$0")/../templates/$TEMPLATE"
if [ ! -d "$TEMPLATE_DIR" ]; then
  echo "Error: Template $TEMPLATE not found"
  exit 1
fi

cp -r "$TEMPLATE_DIR"/* "$PROJECT_DIR/"

# Update configuration
cat > "$PROJECT_DIR/.env" <<EOF
PROJECT_NAME=$PROJECT_NAME
DOMAIN=$DOMAIN
AGENTS=${AGENTS:-Noble,GrantExpert,SupportAgent}
EOF

# Load API keys from vault
if [ -f "$(dirname "$0")/../config/api-keys.vault.json" ]; then
  cp "$(dirname "$0")/../config/api-keys.vault.json" "$PROJECT_DIR/.env.vault"
fi

echo -e "${GREEN}✅ Project initialized at $PROJECT_DIR${NC}"
echo -e "${YELLOW}Next: Deploy with ./scripts/deploy-vps.sh${NC}"
