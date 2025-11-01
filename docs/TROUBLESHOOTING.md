# Troubleshooting Guide

Common issues and solutions for the Universal AI Voice Automation Framework.

## Table of Contents

1. [Deployment Issues](#deployment-issues)
2. [Webhook Issues](#webhook-issues)
3. [DNS and Networking](#dns-and-networking)
4. [Docker Issues](#docker-issues)
5. [API Integration Issues](#api-integration-issues)

---

## Deployment Issues

### Terraform Fails to Provision VPS

**Symptoms:**
- `terraform apply` fails with authentication errors
- "Invalid credentials" error

**Solutions:**

1. **Check AWS credentials:**
   ```bash
   # Verify credentials in vault
   cat config/api-keys.vault.json | grep aws
   
   # Or set environment variables
   export AWS_ACCESS_KEY_ID=your_key
   export AWS_SECRET_ACCESS_KEY=your_secret
   ```

2. **Verify IAM permissions:**
   - Ensure your AWS user has EC2, VPC, and Security Group permissions
   - Check in AWS Console → IAM → Users

3. **Check region availability:**
   ```bash
   # Some regions may not support all instance types
   # Try changing region in variables.tf
   ```

### Docker Build Fails

**Symptoms:**
- `docker build` or `docker-compose up` fails
- Dependency installation errors

**Solutions:**

1. **Clear Docker cache:**
   ```bash
   docker system prune -a
   docker-compose build --no-cache
   ```

2. **Check Playwright installation:**
   ```bash
   # Playwright needs system dependencies
   # Ensure Dockerfile includes: playwright install-deps
   ```

3. **Memory issues:**
   ```bash
   # Increase Docker memory limit in Docker Desktop settings
   # Or use a larger VPS instance type
   ```

---

## Webhook Issues

### Twilio Webhooks Return Errors

**Symptoms:**
- Calls connect but bot doesn't respond
- "11200: HTTP retrieval failure" error in Twilio

**Solutions:**

1. **Check webhook URL accessibility:**
   ```bash
   curl https://your-domain.com/webhook/twilio-voice
   # Should return 200 or 405, not 404
   ```

2. **Verify SSL certificate:**
   - Twilio requires HTTPS
   - Check Cloudflare SSL settings (should be "Full" or "Full (strict)")
   - Test with: `curl -v https://your-domain.com/health`

3. **Check application logs:**
   ```bash
   docker logs <container-name>
   # Look for errors when webhook is called
   ```

4. **Test webhook manually:**
   ```bash
   curl -X POST https://your-domain.com/webhook/twilio-voice \
     -d "From=+15555551234" \
     -d "SpeechResult=test"
   # Should return TwiML XML
   ```

### Webhooks Timeout

**Symptoms:**
- Calls disconnect after a few seconds
- Timeout errors in logs

**Solutions:**

1. **Optimize intent processing:**
   - Reduce Playwright page load waits
   - Cache frequently accessed data
   - Process heavy operations asynchronously

2. **Increase timeout in Twilio:**
   - In TwiML `<Gather>`, set higher `timeout` value

---

## DNS and Networking

### Domain Not Resolving

**Symptoms:**
- `nslookup domain.com` returns no results
- Cannot access application via domain

**Solutions:**

1. **Check DNS propagation:**
   ```bash
   nslookup your-domain.com
   dig your-domain.com
   # Wait up to 24 hours for full propagation
   ```

2. **Verify Cloudflare settings:**
   - Check DNS records in Cloudflare dashboard
   - Ensure A record points to correct IP
   - Check that proxy is enabled (orange cloud)

3. **Test with IP directly:**
   ```bash
   curl http://VPS_IP:3001/health
   # If this works, issue is with DNS
   ```

### Cloudflare Tunnel Not Working

**Symptoms:**
- Tunnel shows as connected but site unreachable
- 502/503 errors

**Solutions:**

1. **Check tunnel status:**
   ```bash
   cloudflared tunnel info my-tunnel
   cloudflared tunnel list
   ```

2. **Verify config.yml:**
   ```bash
   cat ~/.cloudflared/config.yml
   # Check hostname and service entries
   ```

3. **Restart tunnel:**
   ```bash
   sudo systemctl restart cloudflared
   # Or kill and restart manually
   ```

4. **Check application is running:**
   ```bash
   curl http://localhost:3001/health
   # Should return {"ok": true}
   ```

---

## Docker Issues

### Container Keeps Restarting

**Symptoms:**
- `docker ps` shows container constantly restarting
- Application not accessible

**Solutions:**

1. **Check logs:**
   ```bash
   docker logs --tail 100 <container-name>
   # Look for startup errors
   ```

2. **Common issues:**
   - Missing environment variables
   - Port already in use
   - Dependencies not installed

3. **Fix environment variables:**
   ```bash
   # Ensure .env file exists and has correct values
   cat .env
   ```

4. **Check port conflicts:**
   ```bash
   sudo netstat -tulpn | grep 3001
   # If port is in use, stop the other service or use different port
   ```

### Out of Memory Errors

**Symptoms:**
- Container crashes with OOM error
- Playwright fails to launch browser

**Solutions:**

1. **Increase container memory:**
   ```yaml
   # In docker-compose.yml
   services:
     app:
       mem_limit: 2g
   ```

2. **Use headless Playwright:**
   ```python
   # Already configured by default
   browser = await playwright.chromium.launch(headless=True)
   ```

3. **Upgrade VPS instance:**
   - Use at least t3.medium for Playwright
   - Consider t3.large for production

---

## API Integration Issues

### ElevenLabs API Errors

**Symptoms:**
- "Invalid API key" errors
- Agent calls fail

**Solutions:**

1. **Verify API key:**
   ```bash
   # Check vault
   cat config/api-keys.vault.json | grep elevenlabs
   ```

2. **Test API directly:**
   ```bash
   curl https://api.elevenlabs.io/v1/user \
     -H "xi-api-key: YOUR_API_KEY"
   ```

3. **Check API limits:**
   - Verify you haven't exceeded rate limits
   - Check your ElevenLabs dashboard

### Twilio API Errors

**Symptoms:**
- Cannot send SMS
- Authentication fails

**Solutions:**

1. **Verify credentials:**
   ```python
   from twilio.rest import Client
   client = Client(account_sid, auth_token)
   # Should not raise exception
   ```

2. **Check phone number:**
   - Ensure number is verified in Twilio
   - Verify number format: +1XXXXXXXXXX

### AWS S3 Errors

**Symptoms:**
- Cannot upload files
- Access denied errors

**Solutions:**

1. **Check IAM permissions:**
   - Ensure user has S3 write permissions
   - Verify bucket policy

2. **Test with AWS CLI:**
   ```bash
   aws s3 ls s3://your-bucket-name
   ```

---

## Playwright Issues

### Browser Won't Launch

**Symptoms:**
- "Browser executable not found"
- Browser launch timeout

**Solutions:**

1. **Install browser:**
   ```bash
   playwright install chromium
   playwright install-deps chromium
   ```

2. **Inside Docker:**
   - Ensure Dockerfile includes:
     ```dockerfile
     RUN playwright install chromium
     RUN playwright install-deps chromium
     ```

### Page Load Timeouts

**Symptoms:**
- Automation hangs on page load
- Timeout errors in logs

**Solutions:**

1. **Increase timeouts:**
   ```python
   await page.goto(url, timeout=60000)  # 60 seconds
   ```

2. **Wait for specific state:**
   ```python
   await page.wait_for_load_state('networkidle')
   ```

3. **Use faster selectors:**
   - Use ID selectors when possible
   - Avoid complex CSS selectors

---

## Performance Issues

### Slow Response Times

**Symptoms:**
- Webhooks take too long to respond
- Calls disconnect before completion

**Solutions:**

1. **Profile slow operations:**
   - Add logging to measure time
   - Identify bottlenecks

2. **Optimize Playwright:**
   - Disable images: `await page.route("**/*.{png,jpg,jpeg}", lambda route: route.abort())`
   - Use single browser instance
   - Reuse pages when possible

3. **Cache data:**
   - Cache search results
   - Store frequently accessed data in memory

---

## Getting More Help

### Collect Debug Information

```bash
# System info
uname -a
docker --version
python --version

# Application logs
docker logs --tail 500 <container-name> > app.log

# Network info
curl -v https://your-domain.com/health > health.log 2>&1

# Cloudflare tunnel (if used)
cloudflared tunnel info > tunnel.log
```

### Where to Get Support

1. **GitHub Issues**: https://github.com/stampedehosting/universal-ai-voice-framework/issues
2. **Email**: stampedehosting@gmail.com
3. **Documentation**: See [docs/](.)

### Reporting Bugs

Include:
- Error messages (full stack trace)
- Steps to reproduce
- Environment details (OS, Docker version, etc.)
- Relevant logs
- Configuration (sanitize API keys!)
