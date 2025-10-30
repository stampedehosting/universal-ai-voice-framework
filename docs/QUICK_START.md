# Quick Start Guide

## Get Your First System Running in 5 Minutes

This guide will walk you through deploying your first AI voice automation system using the Universal AI Voice Automation Framework.

---

## Prerequisites

Before you begin, ensure you have:

- ✅ A domain name (e.g., `myapp.com`)
- ✅ API keys configured in `config/api-keys.vault.json`
- ✅ Basic command line knowledge
- ✅ Git installed on your machine

---

## Step 1: Clone the Repository (30 seconds)

```bash
git clone https://github.com/stampedehosting/universal-ai-voice-framework.git
cd universal-ai-voice-framework
```

---

## Step 2: Configure API Keys (1 minute)

### Copy the Template

```bash
cp config/api-keys.vault.template.json config/api-keys.vault.json
```

### Fill in Your Keys

Edit `config/api-keys.vault.json` with your actual API keys:

```json
{
  "elevenlabs": {
    "api_key": "sk_your_elevenlabs_key",
    "default_agent": "your_default_agent_id"
  },
  "twilio": {
    "account_sid": "ACxxxxx",
    "auth_token": "your_auth_token",
    "numbers": ["+17473460766"]
  },
  "aws": {
    "ses_region": "us-west-2",
    "access_key_id": "AKIAxxxxx",
    "secret_access_key": "your_secret_key",
    "s3_bucket": "your-bucket-name"
  },
  "cloudflare": {
    "api_token": "your_cloudflare_token"
  }
}
```

### Encrypt the Vault (Optional but Recommended)

```bash
./scripts/encrypt-vault.sh
```

---

## Step 3: Deploy Your System (3 minutes)

### One-Command Deployment

```bash
./deploy.sh \
  --name "my-assistant" \
  --domain "myapp.com" \
  --use-case "customer support"
```

### What Happens Next

The script will automatically:

1. ✅ Initialize the project from the template
2. ✅ Configure Cloudflare Tunnel and DNS
3. ✅ Provision a VPS on AWS
4. ✅ Deploy the application via Docker
5. ✅ Configure Twilio webhooks
6. ✅ Run health checks

---

## Step 4: Test Your System (30 seconds)

### Check Health Endpoint

```bash
curl https://myapp.com/health
```

**Expected Response:**
```json
{"ok": true}
```

### View Available Agents

```bash
curl https://myapp.com/agents
```

### Make a Test Call

Call your Twilio number and say:
> "Open GitHub"

The system should respond and perform the action.

---

## Step 5: Customize (Optional)

### Add Custom Intents

Edit `app/intents.py` in your deployed project:

```python
@intent_handler("search for grants")
async def search_grants(transcript: str, auto: PlaywrightAuto):
    query = extract_query(transcript)
    await auto.goto("https://grants.gov")
    await auto.type_text(query)
    # ... your automation logic
```

### Redeploy

```bash
./scripts/redeploy.sh --project "my-assistant"
```

---

## Common Use Cases

### Grant Assistance Bot

```bash
./deploy.sh \
  --name "grant-helper" \
  --domain "granthelp.ai" \
  --use-case "grant assistance" \
  --agents "Noble,GrantExpert"
```

### Payment Processing Agent

```bash
./deploy.sh \
  --name "payment-bot" \
  --domain "paymenthelp.com" \
  --use-case "payment processing" \
  --agents "PaymentAgent,SupportAgent"
```

### Real Estate Assistant

```bash
./deploy.sh \
  --name "realestate-ai" \
  --domain "homes.ai" \
  --use-case "real estate" \
  --agents "PropertyAgent,SchedulingAgent"
```

---

## Troubleshooting

### Deployment Failed

```bash
# Check logs
./scripts/check-logs.sh --project "my-assistant"

# Retry deployment
./deploy.sh --name "my-assistant" --domain "myapp.com"
```

### Webhooks Not Working

1. Verify Twilio configuration:
   ```bash
   ./scripts/verify-twilio.sh --domain "myapp.com"
   ```

2. Check Cloudflare Tunnel status:
   ```bash
   cloudflared tunnel info
   ```

3. Test webhook manually:
   ```bash
   curl -X POST https://myapp.com/webhook/twilio-voice \
     -d "From=+15555551234&SpeechResult=test"
   ```

### DNS Not Resolving

```bash
# Check DNS propagation
nslookup myapp.com

# Verify Cloudflare configuration
./scripts/check-dns.sh --domain "myapp.com"
```

---

## Next Steps

- 📚 Read the [API Reference](API_REFERENCE.md)
- 🔧 Learn about [Custom Intents](../prompts/UNIVERSAL_PROMPT.md)
- 🚀 Explore [Advanced Deployment](DEPLOYMENT_GUIDE.md)
- 💡 Check out [Example Projects](../prompts/examples/)

---

## Need Help?

- 📖 [Full Documentation](../README.md)
- 🐛 [Report Issues](https://github.com/stampedehosting/universal-ai-voice-framework/issues)
- 📧 [Email Support](mailto:stampedehosting@gmail.com)

---

**Congratulations! You've deployed your first AI voice automation system. 🎉**

