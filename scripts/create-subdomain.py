#!/usr/bin/env python3
"""
Create subdomain on Cloudflare
"""

import argparse
import json
import requests
import sys
from pathlib import Path


def load_vault_credentials():
    """Load Cloudflare credentials from vault"""
    vault_path = Path(__file__).parent.parent / "config" / "api-keys.vault.json"
    
    if not vault_path.exists():
        print(f"Error: Vault file not found at {vault_path}")
        sys.exit(1)
    
    with open(vault_path) as f:
        vault = json.load(f)
    
    return vault.get("cloudflare", {})


def create_subdomain(subdomain, domain, target_ip, api_token, zone_id):
    """Create DNS A record on Cloudflare"""
    url = f"https://api.cloudflare.com/client/v4/zones/{zone_id}/dns_records"
    
    headers = {
        "Authorization": f"Bearer {api_token}",
        "Content-Type": "application/json"
    }
    
    data = {
        "type": "A",
        "name": subdomain,
        "content": target_ip,
        "ttl": 1,
        "proxied": True
    }
    
    response = requests.post(url, headers=headers, json=data)
    result = response.json()
    
    if result.get("success"):
        print(f"✅ Subdomain created successfully")
        print(f"URL: https://{subdomain}.{domain}")
        return True
    else:
        print(f"❌ Failed to create subdomain")
        print(json.dumps(result, indent=2))
        return False


def main():
    parser = argparse.ArgumentParser(description="Create subdomain on Cloudflare")
    parser.add_argument("--subdomain", required=True, help="Subdomain name")
    parser.add_argument("--domain", required=True, help="Base domain")
    parser.add_argument("--ip", required=True, help="Target IP address")
    
    args = parser.parse_args()
    
    # Load credentials
    cf_config = load_vault_credentials()
    api_token = cf_config.get("api_token")
    zone_id = cf_config.get("zone_id")
    
    if not api_token or not zone_id:
        print("Error: Cloudflare credentials not found in vault")
        sys.exit(1)
    
    # Create subdomain
    success = create_subdomain(
        args.subdomain,
        args.domain,
        args.ip,
        api_token,
        zone_id
    )
    
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
