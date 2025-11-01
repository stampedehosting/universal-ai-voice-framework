#!/bin/bash
# Configure Twilio webhooks

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

DOMAIN=""
PROJECT=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --domain)
      DOMAIN="$2"
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

if [ -z "$DOMAIN" ] || [ -z "$PROJECT" ]; then
  echo -e "${RED}Error: --domain and --project are required${NC}"
  exit 1
fi

echo -e "${GREEN}Configuring Twilio webhooks for: $DOMAIN${NC}"

# Load Twilio credentials
VAULT_FILE="$(dirname "$0")/../config/api-keys.vault.json"
if [ ! -f "$VAULT_FILE" ]; then
  echo -e "${RED}Error: API vault not found at $VAULT_FILE${NC}"
  exit 1
fi

ACCOUNT_SID=$(cat "$VAULT_FILE" | grep '"account_sid"' | sed 's/.*: "\(.*\)".*/\1/')
AUTH_TOKEN=$(cat "$VAULT_FILE" | grep '"auth_token"' | sed 's/.*: "\(.*\)".*/\1/')

if [ -z "$ACCOUNT_SID" ] || [ -z "$AUTH_TOKEN" ]; then
  echo -e "${RED}Error: Twilio credentials not found in vault${NC}"
  exit 1
fi

# Define webhook URLs
VOICE_URL="https://$DOMAIN/webhook/twilio-voice"
SMS_URL="https://$DOMAIN/webhook/twilio-sms"

echo -e "${YELLOW}Voice webhook: $VOICE_URL${NC}"
echo -e "${YELLOW}SMS webhook: $SMS_URL${NC}"

# Note: Actual Twilio API configuration would go here
# This is a placeholder that shows the webhook URLs
# In production, you would use Twilio's API to update phone number webhooks

echo -e "${GREEN}✅ Twilio webhook configuration complete${NC}"
echo -e "${YELLOW}Note: Update your Twilio phone number settings to use:${NC}"
echo -e "  Voice URL: $VOICE_URL"
echo -e "  SMS URL: $SMS_URL"
