#!/bin/bash
# Setup DNS and Cloudflare Tunnel

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

DOMAIN=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --domain)
      DOMAIN="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

if [ -z "$DOMAIN" ]; then
  echo "Error: --domain is required"
  exit 1
fi

echo -e "${GREEN}Setting up DNS for: $DOMAIN${NC}"

# Load Cloudflare credentials
if [ -f "$(dirname "$0")/../config/api-keys.vault.json" ]; then
  CF_API_TOKEN=$(cat "$(dirname "$0")/../config/api-keys.vault.json" | grep -o '"api_token"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: "\(.*\)"/\1/')
  CF_ZONE_ID=$(cat "$(dirname "$0")/../config/api-keys.vault.json" | grep -o '"zone_id"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: "\(.*\)"/\1/')
fi

# Create Cloudflare Tunnel (if cloudflared is installed)
if command -v cloudflared &> /dev/null; then
  echo -e "${YELLOW}Creating Cloudflare Tunnel...${NC}"
  
  # Create tunnel
  TUNNEL_NAME="${DOMAIN//./-}-tunnel"
  cloudflared tunnel create "$TUNNEL_NAME" 2>/dev/null || echo "Tunnel may already exist"
  
  # Route DNS
  cloudflared tunnel route dns "$TUNNEL_NAME" "$DOMAIN" 2>/dev/null || echo "DNS route may already exist"
  
  echo -e "${GREEN}✅ Cloudflare Tunnel configured${NC}"
else
  echo -e "${YELLOW}⚠️  cloudflared not installed, skipping tunnel setup${NC}"
  echo -e "${YELLOW}   Install with: brew install cloudflare/cloudflare/cloudflared${NC}"
fi

echo -e "${GREEN}✅ DNS setup complete${NC}"
