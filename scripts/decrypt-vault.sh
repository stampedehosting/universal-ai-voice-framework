#!/bin/bash
# Decrypt API keys vault

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ENCRYPTED_FILE="$(dirname "$0")/../config/api-keys.vault.json.enc"
VAULT_FILE="$(dirname "$0")/../config/api-keys.vault.json"

if [ ! -f "$ENCRYPTED_FILE" ]; then
  echo -e "${RED}Error: Encrypted vault file not found at $ENCRYPTED_FILE${NC}"
  exit 1
fi

echo -e "${YELLOW}Decrypting vault file...${NC}"

# Prompt for password
read -s -p "Enter decryption password: " PASSWORD
echo

# Decrypt using openssl
openssl enc -aes-256-cbc -d -in "$ENCRYPTED_FILE" -out "$VAULT_FILE" -k "$PASSWORD"

if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ Vault decrypted successfully${NC}"
  echo -e "${YELLOW}Decrypted file: $VAULT_FILE${NC}"
else
  echo -e "${RED}❌ Decryption failed - check your password${NC}"
  exit 1
fi
