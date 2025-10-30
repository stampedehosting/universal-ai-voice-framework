# Universal AI Voice Automation Framework

**Deploy complete AI voice automation systems in under 5 minutes.**

This framework automates the entire process of building, configuring, and deploying AI voice automation systems with ElevenLabs, Twilio, Playwright, and more.

---

## 🚀 Quick Start

### One-Command Deployment

```bash
./deploy.sh --name "my-assistant" --domain "myapp.com" --use-case "grant assistance"
```

**That's it.** Your system is live in under 5 minutes.

---

## ✨ Features

- ✅ **One-Click Deployment**: Provision VPS, configure DNS, deploy application
- ✅ **Automated API Key Management**: Encrypted vault with auto-injection
- ✅ **100 ElevenLabs Agents**: Pre-configured and ready to use
- ✅ **Twilio Integration**: Voice and SMS webhooks automatically configured
- ✅ **Cloudflare Tunnel**: Secure public access without port forwarding
- ✅ **Playwright Automation**: Browser control via voice commands
- ✅ **Intent Engine**: Natural language → Actions
- ✅ **Multi-Platform Storage**: S3, Google Drive, Trello, Go High Level
- ✅ **Voice-Activated Deployment**: Deploy systems by talking to your AI agent
- ✅ **Transcript-to-Application**: Build apps from conversation transcripts

---

## 📦 What's Included

### Templates
- **FastAPI Base**: Python server with Twilio webhooks, ElevenLabs, Playwright
- **Express Base**: Node.js server with full integration suite
- **Hybrid**: Full-stack with React frontend + FastAPI backend

### Provisioning
- **Terraform**: AWS, DigitalOcean, Cloudflare infrastructure
- **Ansible**: Automated server configuration
- **Docker**: Containerized deployment

### Integrations
- ElevenLabs (100 conversational AI agents)
- Twilio (Voice + SMS)
- Amazon SES (Email)
- Cloudflare (Tunnel + DNS)
- Playwright (Browser automation)
- OpenCV (Computer vision - optional)
- Go High Level, Trello, Google Drive

---

## 🎯 Use Cases

Build any of these in minutes:

- **Grant Assistance Bot**: Help nonprofits find and apply for grants
- **Payment Processing Agent**: Guide users through payment workflows
- **Real Estate Assistant**: Property search and appointment scheduling
- **Customer Support Bot**: Multi-channel support with screen sharing
- **Educational Tutor**: Interactive learning with visual demonstrations
- **Sales Agent**: Lead qualification and demo scheduling

---

## 🛠️ Installation

### Prerequisites

```bash
# Install dependencies
brew install terraform ansible docker cloudflared  # macOS
# or
sudo apt install terraform ansible docker.io  # Linux
```

### Clone Repository

```bash
git clone https://github.com/stampedehosting/universal-ai-voice-framework.git
cd universal-ai-voice-framework
```

### Configure API Keys

```bash
# Copy template and fill in your keys
cp config/api-keys.vault.template.json config/api-keys.vault.json
nano config/api-keys.vault.json

# Encrypt the vault
./scripts/encrypt-vault.sh
```

---

## 📖 Usage

### Method 1: Command Line

```bash
# Full deployment
./deploy.sh \
  --name "grant-assistant" \
  --domain "granthelp.ai" \
  --template "fastapi-base" \
  --agents "Noble,GrantExpert,SupportAgent"
```

### Method 2: Interactive

```bash
./scripts/init-project.sh
# Follow the prompts
```

### Method 3: Voice Command

Talk to your AI agent:
> "Deploy a grant assistance system on granthelp.ai with Noble and GrantExpert agents"

### Method 4: From Transcript

```bash
./scripts/build-from-transcript.sh --file transcript.txt
```

---

## 🏗️ Architecture

```
User Call/SMS → Twilio → Cloudflare Tunnel → Your VPS
                                              ↓
                                         FastAPI Server
                                              ↓
                                    ┌─────────┴─────────┐
                                    ↓                   ↓
                              Intent Engine      ElevenLabs Agent
                                    ↓                   ↓
                              Playwright         Voice Response
                              Automation              ↓
                                    ↓            Follow-up Email
                              Browser Actions    (Amazon SES)
```

---

## 📚 Documentation

- [Quick Start Guide](docs/QUICK_START.md)
- [API Reference](docs/API_REFERENCE.md)
- [Deployment Guide](docs/DEPLOYMENT_GUIDE.md)
- [Universal Prompt](prompts/UNIVERSAL_PROMPT.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

---

## 🔧 Configuration

### deploy-config.yml

```yaml
project:
  name: "my-assistant"
  domain: "myapp.com"
  template: "fastapi-base"

agents:
  - "Noble"
  - "GrantExpert"
  - "SupportAgent"

infrastructure:
  provider: "aws"
  region: "us-west-2"
  size: "t3.medium"

integrations:
  twilio: true
  elevenlabs: true
  ses: true
  cloudflare: true
  playwright: true
```

---

## 🚀 Deployment Options

### AWS
```bash
./scripts/deploy-vps.sh --provider aws --region us-west-2
```

### DigitalOcean
```bash
./scripts/deploy-vps.sh --provider digitalocean --region nyc3
```

### Local Development
```bash
docker-compose up
```

---

## 🧪 Testing

```bash
# Test deployment
./scripts/test-deployment.sh --url https://myapp.com

# Test webhooks
curl -X POST https://myapp.com/webhook/twilio-voice \
  -d "From=+15555551234&SpeechResult=open github"

# Test agents
curl https://myapp.com/agents
```

---

## 🔐 Security

- ✅ Encrypted API key vault
- ✅ Twilio signature verification
- ✅ Rate limiting
- ✅ HTTPS only (Cloudflare)
- ✅ IP whitelisting (optional)
- ✅ Environment variable isolation

---

## 📊 Monitoring

Built-in monitoring for:
- Response times
- Success rates
- Agent performance
- Error tracking
- Call volume
- Webhook health

---

## 🤝 Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📄 License

MIT License - see [LICENSE](LICENSE)

---

## 🆘 Support

- **Documentation**: [docs/](docs/)
- **Issues**: [GitHub Issues](https://github.com/stampedehosting/universal-ai-voice-framework/issues)
- **Email**: stampedehosting@gmail.com

---

## 🎉 Success Stories

> "Deployed a complete grant assistance system in 4 minutes. Mind-blowing." - User

> "The voice-activated deployment is game-changing. Just talk and it builds." - Developer

---

## 🗺️ Roadmap

- [ ] Computer vision integration (OpenCV)
- [ ] Multi-language support
- [ ] Advanced A/B testing
- [ ] Auto-scaling
- [ ] Real-time analytics dashboard
- [ ] Mobile app templates

---

**Built with ❤️ by Stampede Hosting**

Deploy your first system in the next 5 minutes →

