# Quick Reference Card

## Essential Commands

### Initial Setup
```bash
# Clone repository
git clone https://github.com/stampedehosting/universal-ai-voice-framework.git
cd universal-ai-voice-framework

# Configure API keys
cp config/api-keys.vault.template.json config/api-keys.vault.json
nano config/api-keys.vault.json  # Edit with your keys

# Encrypt vault (optional)
./scripts/encrypt-vault.sh
```

### One-Click Deployment
```bash
./deploy.sh --name "my-app" --domain "example.com"
```

### Manual Deployment Steps
```bash
# 1. Initialize project
./scripts/init-project.sh --name "my-app" --domain "example.com"

# 2. Setup DNS
./scripts/setup-dns.sh --domain "example.com"

# 3. Deploy VPS
./scripts/deploy-vps.sh --provider aws --region us-west-2 --project "my-app"

# 4. Configure Twilio
./scripts/configure-twilio.sh --domain "example.com" --project "my-app"

# 5. Test deployment
./scripts/test-deployment.sh --url "https://example.com"
```

### Local Development
```bash
cd templates/fastapi-base
cp .env.template .env
nano .env  # Configure

# Run with Docker
docker-compose up

# Or run directly
pip install -r requirements.txt
uvicorn app.main:app --reload
```

### Testing
```bash
# Integration tests
./scripts/test-framework.sh

# Unit tests
cd templates/fastapi-base
pip install -r requirements.txt -r tests/requirements-test.txt
pytest tests/

# Test webhooks
curl -X POST http://localhost:3001/webhook/twilio-voice \
  -d "SpeechResult=test command"
```

### Adding Custom Intents
```python
# Edit templates/fastapi-base/app/intents.py
from app.intents import intent_handler

@intent_handler(r"do something|perform action")
async def handle_custom_action(text: str, automation) -> str:
    # Your custom logic here
    await automation.navigate_to("https://example.com")
    return "Action completed!"
```

### Cloudflare Tunnel Setup
```bash
# On VPS
cloudflared tunnel login
cloudflared tunnel create my-tunnel
cloudflared tunnel route dns my-tunnel example.com

# Create config
nano ~/.cloudflared/config.yml
# Add tunnel configuration

# Run tunnel
cloudflared tunnel run my-tunnel
```

### Terraform Commands
```bash
cd provisioning/terraform/aws

# Initialize
terraform init

# Plan deployment
terraform plan

# Apply changes
terraform apply

# Get outputs
terraform output vps_ip

# Destroy infrastructure
terraform destroy
```

### Docker Commands
```bash
# Build image
docker build -t my-app .

# Run container
docker run -d -p 3001:3001 --env-file .env my-app

# View logs
docker logs <container-id>

# Stop container
docker stop <container-id>

# Clean up
docker system prune -a
```

### Useful Endpoints

**Health Check:**
```bash
curl https://your-domain.com/health
```

**List Agents:**
```bash
curl https://your-domain.com/agents
```

**Twilio Voice Webhook:**
```
POST https://your-domain.com/webhook/twilio-voice
```

**Twilio SMS Webhook:**
```
POST https://your-domain.com/webhook/twilio-sms
```

### Environment Variables

**Required:**
- `ELEVENLABS_API_KEY` - ElevenLabs API key
- `TWILIO_ACCOUNT_SID` - Twilio account SID
- `TWILIO_AUTH_TOKEN` - Twilio auth token

**Optional:**
- `PROJECT_NAME` - Project name
- `DOMAIN` - Domain name
- `AWS_ACCESS_KEY_ID` - AWS access key
- `AWS_SECRET_ACCESS_KEY` - AWS secret key
- `CLOUDFLARE_API_TOKEN` - Cloudflare API token

### Troubleshooting

**Check logs:**
```bash
docker logs <container-name>
tail -f /var/log/cloudflared.log
```

**Test DNS:**
```bash
nslookup your-domain.com
dig your-domain.com
```

**Verify webhooks:**
```bash
curl https://your-domain.com/webhook/twilio-voice
```

**Restart services:**
```bash
docker-compose restart
systemctl restart cloudflared
```

### Documentation

- **Main README:** [README.md](README.md)
- **Quick Start:** [docs/QUICK_START.md](docs/QUICK_START.md)
- **API Reference:** [docs/API_REFERENCE.md](docs/API_REFERENCE.md)
- **Deployment:** [docs/DEPLOYMENT_GUIDE.md](docs/DEPLOYMENT_GUIDE.md)
- **Troubleshooting:** [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

### Support

- **Issues:** https://github.com/stampedehosting/universal-ai-voice-framework/issues
- **Email:** stampedehosting@gmail.com

### File Locations

- **Scripts:** `scripts/`
- **Config:** `config/`
- **Templates:** `templates/fastapi-base/`
- **Terraform:** `provisioning/terraform/aws/`
- **Docs:** `docs/`
- **Examples:** `examples/`

### Built-in Intents

- `"open [website]"` - Opens a website
- `"search for [query]"` - Searches Google
- `"help"` - Shows available commands

### Common Patterns

**Search and notify:**
```python
@intent_handler(r"search and email")
async def search_and_email(text, automation):
    results = await automation.search_google(query)
    await send_email(results)
    return "Results sent to your email"
```

**Multi-step workflow:**
```python
@intent_handler(r"complete workflow")
async def workflow(text, automation):
    await automation.navigate_to("https://site.com")
    await automation.type_text("#input", "data")
    await automation.click_element("button")
    return "Workflow completed"
```

---

**Quick deployment:** `./deploy.sh --name "my-app" --domain "example.com"`
