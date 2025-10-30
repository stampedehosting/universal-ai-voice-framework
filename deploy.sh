#!/bin/bash
# Universal AI Voice Automation Framework - One-Click Deployment Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Parse arguments
PROJECT_NAME=""
DOMAIN=""
TEMPLATE="fastapi-base"
AGENTS=""
USE_CASE=""

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
    --use-case)
      USE_CASE="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Validate required arguments
if [ -z "$PROJECT_NAME" ] || [ -z "$DOMAIN" ]; then
  echo -e "${RED}Error: --name and --domain are required${NC}"
  echo "Usage: ./deploy.sh --name <project-name> --domain <domain> [--template <template>] [--agents <agents>] [--use-case <use-case>]"
  exit 1
fi

echo -e "${GREEN}🚀 Universal AI Voice Automation Framework${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Project Name: $PROJECT_NAME"
echo "Domain: $DOMAIN"
echo "Template: $TEMPLATE"
echo "Agents: ${AGENTS:-Default agents}"
echo "Use Case: ${USE_CASE:-General purpose}"
echo ""

# Step 1: Initialize project
echo -e "${YELLOW}[1/5] Initializing project...${NC}"
./scripts/init-project.sh --name "$PROJECT_NAME" --domain "$DOMAIN" --template "$TEMPLATE" --agents "$AGENTS"

# Step 2: Setup DNS
echo -e "${YELLOW}[2/5] Configuring DNS and Cloudflare Tunnel...${NC}"
./scripts/setup-dns.sh --domain "$DOMAIN"

# Step 3: Deploy VPS
echo -e "${YELLOW}[3/5] Deploying to VPS...${NC}"
./scripts/deploy-vps.sh --provider "aws" --region "us-west-2" --project "$PROJECT_NAME"

# Step 4: Configure webhooks
echo -e "${YELLOW}[4/5] Configuring Twilio webhooks...${NC}"
./scripts/configure-twilio.sh --domain "$DOMAIN" --project "$PROJECT_NAME"

# Step 5: Test deployment
echo -e "${YELLOW}[5/5] Testing deployment...${NC}"
./scripts/test-deployment.sh --url "https://$DOMAIN"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "🌐 URL: https://$DOMAIN"
echo "📞 Twilio Voice: https://$DOMAIN/webhook/twilio-voice"
echo "💬 Twilio SMS: https://$DOMAIN/webhook/twilio-sms"
echo "🤖 Agents: View at https://$DOMAIN/agents"
echo ""
echo "Next steps:"
echo "  1. Test by calling your Twilio number"
echo "  2. View logs: ssh into VPS and run 'docker logs <container>'"
echo "  3. Monitor: https://$DOMAIN/health"
echo ""
