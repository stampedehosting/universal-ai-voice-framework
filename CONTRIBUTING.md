# Contributing to Universal AI Voice Automation Framework

Thank you for your interest in contributing!

## How to Contribute

### Reporting Issues

- Use GitHub Issues to report bugs
- Include detailed reproduction steps
- Provide environment details (OS, Python version, etc.)

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests if available
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Development Setup

```bash
# Clone the repo
git clone https://github.com/stampedehosting/universal-ai-voice-framework.git
cd universal-ai-voice-framework

# Create API keys vault
cp config/api-keys.vault.template.json config/api-keys.vault.json
# Edit config/api-keys.vault.json with your keys

# Test FastAPI template
cd templates/fastapi-base
pip install -r requirements.txt
uvicorn app.main:app --reload
```

## Code Style

- Follow PEP 8 for Python code
- Use meaningful variable names
- Add comments for complex logic
- Keep functions focused and small

## Adding New Templates

1. Create directory under `templates/`
2. Include Dockerfile, requirements, and app code
3. Add documentation in template README
4. Update main README with template info

## Adding New Scripts

1. Add script to `scripts/` directory
2. Make it executable (`chmod +x`)
3. Add usage examples in comments
4. Update documentation

## Testing

- Test deployments in development environment first
- Verify webhooks work with Twilio
- Check Cloudflare Tunnel configuration
- Ensure Docker builds succeed

## Questions?

Open an issue or email stampedehosting@gmail.com
