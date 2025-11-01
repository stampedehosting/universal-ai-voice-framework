# FastAPI Base Template

This is the base template for building AI voice automation systems with FastAPI.

## Features

- **Twilio Integration**: Voice and SMS webhooks
- **ElevenLabs**: Conversational AI agents
- **Playwright**: Browser automation
- **Docker**: Containerized deployment

## Quick Start

1. Copy this template to your project directory
2. Update `.env` with your API keys
3. Run with Docker:
   ```bash
   docker-compose up
   ```

## Structure

- `app/main.py` - FastAPI application and webhooks
- `app/intents.py` - Intent handlers for natural language processing
- `app/automation.py` - Playwright browser automation
- `app/elevenlabs_client.py` - ElevenLabs API client

## Adding Custom Intents

Edit `app/intents.py` and use the `@intent_handler` decorator:

```python
@intent_handler(r"search for grants")
async def handle_grant_search(text: str, automation) -> str:
    query = extract_query(text)
    await automation.search_grants(query)
    return f"Searching for grants: {query}"
```

## Testing

```bash
# Health check
curl http://localhost:3001/health

# Test webhook
curl -X POST http://localhost:3001/webhook/twilio-voice \
  -d "SpeechResult=open github"
```
