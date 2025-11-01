#!/bin/bash
# Encrypt API keys vault

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

VAULT_FILE="$(dirname "$0")/../config/api-keys.vault.json"
ENCRYPTED_FILE="$(dirname "$0")/../config/api-keys.vault.json.enc"

if [ ! -f "$VAULT_FILE" ]; then
  echo -e "${RED}Error: Vault file not found at $VAULT_FILE${NC}"
  exit 1
fi

echo -e "${YELLOW}Encrypting vault file...${NC}"

# Prompt for password
read -s -p "Enter encryption password: " PASSWORD
echo

# Encrypt using openssl
openssl enc -aes-256-cbc -salt -in "$VAULT_FILE" -out "$ENCRYPTED_FILE" -k "$PASSWORD"

if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ Vault encrypted successfully${NC}"
  echo -e "${YELLOW}Encrypted file: $ENCRYPTED_FILE${NC}"
  echo -e "${YELLOW}Remember your password - you'll need it to decrypt!${NC}"
else
  echo -e "${RED}❌ Encryption failed${NC}"
  exit 1
fi
