#!/bin/bash
# Test deployment

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

URL=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --url)
      URL="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

if [ -z "$URL" ]; then
  echo -e "${RED}Error: --url is required${NC}"
  exit 1
fi

echo -e "${GREEN}Testing deployment at: $URL${NC}"

# Test health endpoint
echo -e "${YELLOW}Testing health endpoint...${NC}"
HEALTH_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$URL/health" || echo "000")

if [ "$HEALTH_RESPONSE" = "200" ]; then
  echo -e "${GREEN}✅ Health check passed${NC}"
else
  echo -e "${RED}❌ Health check failed (HTTP $HEALTH_RESPONSE)${NC}"
fi

# Test agents endpoint
echo -e "${YELLOW}Testing agents endpoint...${NC}"
AGENTS_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$URL/agents" || echo "000")

if [ "$AGENTS_RESPONSE" = "200" ]; then
  echo -e "${GREEN}✅ Agents endpoint accessible${NC}"
else
  echo -e "${YELLOW}⚠️  Agents endpoint returned HTTP $AGENTS_RESPONSE${NC}"
fi

# Test webhook endpoint
echo -e "${YELLOW}Testing Twilio webhook endpoint...${NC}"
WEBHOOK_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$URL/webhook/twilio-voice" || echo "000")

if [ "$WEBHOOK_RESPONSE" = "200" ] || [ "$WEBHOOK_RESPONSE" = "405" ]; then
  echo -e "${GREEN}✅ Webhook endpoint exists${NC}"
else
  echo -e "${YELLOW}⚠️  Webhook endpoint returned HTTP $WEBHOOK_RESPONSE${NC}"
fi

echo -e "${GREEN}✅ Deployment tests complete${NC}"
