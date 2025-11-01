# Deployment Guide

This guide covers detailed deployment scenarios for the Universal AI Voice Automation Framework.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Local Development](#local-development)
3. [Production Deployment](#production-deployment)
4. [Multiple Subdomains](#multiple-subdomains)
5. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Tools

- **Docker** (v20.10+)
- **Terraform** (v1.0+) - for VPS provisioning
- **Git**
- **Python** (v3.11+)

### Optional Tools

- **Cloudflared** - for Cloudflare Tunnel
- **AWS CLI** - for AWS management
- **ngrok** - for local webhook testing

### API Keys

You'll need accounts and API keys for:

1. **ElevenLabs** - https://elevenlabs.io
2. **Twilio** - https://twilio.com
3. **AWS** - https://aws.amazon.com
4. **Cloudflare** - https://cloudflare.com

---

## Local Development

### Step 1: Clone and Setup

```bash
git clone https://github.com/stampedehosting/universal-ai-voice-framework.git
cd universal-ai-voice-framework

# Configure API keys
cp config/api-keys.vault.template.json config/api-keys.vault.json
# Edit config/api-keys.vault.json with your keys
```

### Step 2: Run Locally with Docker

```bash
cd templates/fastapi-base

# Create .env file
cp .env.template .env
# Edit .env with your configuration

# Start with Docker Compose
docker-compose up
```

Your application will be available at http://localhost:3001

### Step 3: Test Webhooks with ngrok

```bash
# In a new terminal
ngrok http 3001

# Copy the ngrok URL (e.g., https://abc123.ngrok.io)
# Update Twilio webhook settings to point to:
# https://abc123.ngrok.io/webhook/twilio-voice
```

---

## Production Deployment

### Method 1: One-Click Deployment

```bash
./deploy.sh \
  --name "my-assistant" \
  --domain "myapp.com" \
  --use-case "customer support"
```

This will:
1. Provision an AWS EC2 instance
2. Configure Cloudflare DNS
3. Deploy your application in Docker
4. Configure Twilio webhooks

### Method 2: Manual Step-by-Step

#### Step 1: Provision VPS

```bash
./scripts/deploy-vps.sh \
  --provider aws \
  --region us-west-2 \
  --project my-assistant
```

This creates a VPS and returns its IP address.

#### Step 2: Configure DNS

```bash
./scripts/setup-dns.sh --domain myapp.com
```

Or manually:
- Create A record: `myapp.com` → VPS IP
- Or use Cloudflare Tunnel for automatic routing

#### Step 3: SSH to VPS and Deploy

```bash
# Get VPS IP from Terraform output
VPS_IP=$(cd provisioning/terraform/aws && terraform output -raw vps_ip)

# SSH to VPS
ssh ubuntu@$VPS_IP

# On VPS: Clone repo
cd /opt
git clone https://github.com/stampedehosting/universal-ai-voice-framework.git
cd universal-ai-voice-framework/templates/fastapi-base

# Copy your API keys
# (Upload via scp or use AWS Secrets Manager)

# Build and run
docker-compose up -d
```

#### Step 4: Configure Twilio

```bash
./scripts/configure-twilio.sh \
  --domain myapp.com \
  --project my-assistant
```

Or manually in Twilio Console:
1. Go to Phone Numbers → Active Numbers
2. Click your number
3. Under Voice Configuration, set:
   - **Webhook URL**: `https://myapp.com/webhook/twilio-voice`
   - **HTTP Method**: POST
4. Under Messaging Configuration, set:
   - **Webhook URL**: `https://myapp.com/webhook/twilio-sms`

#### Step 5: Test Deployment

```bash
./scripts/test-deployment.sh --url https://myapp.com
```

---

## Multiple Subdomains

Deploy multiple applications on a single VPS.

### Architecture

```
VPS (54.123.45.67)
├── Nginx (Reverse Proxy)
│   ├── app1.domain.com → localhost:3001
│   ├── app2.domain.com → localhost:3002
│   └── app3.domain.com → localhost:3003
└── Docker Containers
    ├── app1 (port 3001)
    ├── app2 (port 3002)
    └── app3 (port 3003)
```

### Deploy Additional App

```bash
# 1. Create subdomain
./scripts/create-subdomain.py \
  --subdomain app2 \
  --domain myapp.com \
  --ip 54.123.45.67

# 2. Deploy on next available port
ssh ubuntu@54.123.45.67

cd /opt/universal-ai-voice-framework/templates/fastapi-base
docker-compose -p app2 -f docker-compose.yml up -d
# Edit docker-compose.yml to use port 3002

# 3. Configure Nginx reverse proxy
sudo nano /etc/nginx/sites-available/app2.myapp.com
```

Nginx config:
```nginx
server {
    listen 80;
    server_name app2.myapp.com;
    
    location / {
        proxy_pass http://localhost:3002;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

Enable site:
```bash
sudo ln -s /etc/nginx/sites-available/app2.myapp.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

## Cloudflare Tunnel Setup

For secure access without opening ports:

### Step 1: Install cloudflared

```bash
# On VPS
curl -L --output cloudflared.deb \
  https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared.deb
```

### Step 2: Login and Create Tunnel

```bash
cloudflared tunnel login
cloudflared tunnel create my-tunnel
```

### Step 3: Configure Routes

Create `~/.cloudflared/config.yml`:

```yaml
tunnel: YOUR_TUNNEL_ID
credentials-file: /home/ubuntu/.cloudflared/YOUR_TUNNEL_ID.json

ingress:
  - hostname: myapp.com
    service: http://localhost:3001
  - hostname: app2.myapp.com
    service: http://localhost:3002
  - service: http_status:404
```

### Step 4: Route DNS

```bash
cloudflared tunnel route dns my-tunnel myapp.com
cloudflared tunnel route dns my-tunnel app2.myapp.com
```

### Step 5: Run Tunnel

```bash
cloudflared tunnel run my-tunnel

# Or as a service
sudo cloudflared service install
sudo systemctl start cloudflared
```

---

## Troubleshooting

### Application Won't Start

```bash
# Check logs
docker logs <container-name>

# Check if port is available
sudo netstat -tulpn | grep 3001

# Restart container
docker-compose restart
```

### Webhooks Not Working

1. **Check Twilio Configuration**
   ```bash
   curl https://myapp.com/webhook/twilio-voice
   # Should return 405 or valid response
   ```

2. **Verify DNS**
   ```bash
   nslookup myapp.com
   ping myapp.com
   ```

3. **Check Cloudflare SSL**
   - Ensure SSL mode is "Full" or "Full (strict)"
   - Check for SSL/TLS errors in browser

### VPS Connection Issues

```bash
# Check security group (AWS)
# Ensure ports 22, 80, 443 are open

# Test SSH
ssh -v ubuntu@VPS_IP

# Check VPS status in AWS Console
```

### Terraform Errors

```bash
# Reinitialize
cd provisioning/terraform/aws
terraform init -upgrade

# Check state
terraform show

# Destroy and recreate if needed
terraform destroy
terraform apply
```

---

## Best Practices

1. **Security**
   - Use encrypted vault for API keys
   - Enable Cloudflare proxy for DDoS protection
   - Set up firewall rules
   - Use SSH keys instead of passwords

2. **Monitoring**
   - Set up CloudWatch or similar
   - Monitor Docker logs
   - Track webhook response times
   - Monitor API usage

3. **Backups**
   - Backup Terraform state
   - Export Cloudflare DNS records
   - Backup Docker volumes
   - Document custom configurations

4. **Updates**
   - Keep Docker images updated
   - Update Playwright browsers regularly
   - Update Python dependencies
   - Monitor security advisories

---

## Advanced Topics

### Auto-scaling

Use AWS Auto Scaling Groups with the Terraform configuration.

### Load Balancing

Add AWS ALB or Cloudflare Load Balancing for high-traffic applications.

### Multi-region Deployment

Deploy to multiple AWS regions and use Route 53 for geo-routing.

### CI/CD Integration

Set up GitHub Actions for automated deployments on push.

---

For more help, see:
- [Quick Start Guide](QUICK_START.md)
- [API Reference](API_REFERENCE.md)
- [GitHub Issues](https://github.com/stampedehosting/universal-ai-voice-framework/issues)
