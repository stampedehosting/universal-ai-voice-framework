# API Reference

## FastAPI Endpoints

### Health Check

**GET** `/health`

Returns the health status of the application.

**Response:**
```json
{
  "ok": true
}
```

---

### List Agents

**GET** `/agents`

Returns a list of available ElevenLabs agents.

**Response:**
```json
{
  "agents": [
    {"name": "Noble", "id": "agent_noble"},
    {"name": "GrantExpert", "id": "agent_grant_expert"},
    {"name": "SupportAgent", "id": "agent_support"}
  ]
}
```

---

### Twilio Voice Webhook

**POST** `/webhook/twilio-voice`

Handles incoming voice calls from Twilio.

**Parameters:**
- `From` (string): Caller's phone number
- `To` (string): Twilio phone number called
- `SpeechResult` (string): Transcribed speech from caller
- `CallSid` (string): Unique call identifier

**Response:**
Returns TwiML XML for Twilio to execute.

**Example:**
```bash
curl -X POST https://your-domain.com/webhook/twilio-voice \
  -d "From=+15555551234" \
  -d "SpeechResult=open github"
```

---

### Twilio SMS Webhook

**POST** `/webhook/twilio-sms`

Handles incoming SMS messages from Twilio.

**Parameters:**
- `From` (string): Sender's phone number
- `Body` (string): Message content
- `MessageSid` (string): Unique message identifier

**Response:**
Returns TwiML XML for Twilio to execute.

**Example:**
```bash
curl -X POST https://your-domain.com/webhook/twilio-sms \
  -d "From=+15555551234" \
  -d "Body=search for grants"
```

---

## Intent Handlers

Intent handlers are defined in `app/intents.py` using the `@intent_handler` decorator.

### Creating Custom Intents

```python
from app.intents import intent_handler

@intent_handler(r"search for|find")
async def handle_search(text: str, automation) -> str:
    """Handle search queries"""
    query = extract_query(text)
    await automation.search_google(query)
    return f"Searching for: {query}"
```

### Built-in Intents

- **Open Website**: `"open [website]"` - Opens a website
- **Search**: `"search for [query]"` - Searches Google
- **Help**: `"help"` or `"what can you do"` - Shows available commands

---

## Playwright Automation API

### PlaywrightAutomation Class

Located in `app/automation.py`

#### Methods

**`navigate_to(url: str)`**
Navigate to a URL.

```python
await automation.navigate_to("https://github.com")
```

**`search_google(query: str)`**
Search on Google.

```python
await automation.search_google("AI automation")
```

**`search_grants(query: str)`**
Search for grants on grants.gov.

```python
await automation.search_grants("nonprofit funding")
```

**`click_element(selector: str)`**
Click an element by CSS selector.

```python
await automation.click_element("button.submit")
```

**`type_text(selector: str, text: str)`**
Type text into an input field.

```python
await automation.type_text("#search", "query")
```

**`get_text(selector: str) -> str`**
Get text content from an element.

```python
text = await automation.get_text("h1")
```

**`screenshot(path: str)`**
Take a screenshot.

```python
await automation.screenshot("/tmp/screenshot.png")
```

---

## Environment Variables

Set these in your `.env` file:

### Required

- `ELEVENLABS_API_KEY` - ElevenLabs API key
- `TWILIO_ACCOUNT_SID` - Twilio account SID
- `TWILIO_AUTH_TOKEN` - Twilio auth token

### Optional

- `PROJECT_NAME` - Project name (default: "my-assistant")
- `DOMAIN` - Domain name (default: "localhost")
- `ELEVENLABS_DEFAULT_AGENT` - Default agent ID
- `AWS_ACCESS_KEY_ID` - AWS access key
- `AWS_SECRET_ACCESS_KEY` - AWS secret key
- `S3_BUCKET` - S3 bucket name

---

## Error Handling

All intent handlers should handle errors gracefully:

```python
@intent_handler(r"complex action")
async def handle_complex(text: str, automation) -> str:
    try:
        # Your automation logic
        await automation.complex_action()
        return "Action completed successfully"
    except Exception as e:
        return f"I encountered an error: {str(e)}"
```

---

## Testing

### Unit Tests

Run with pytest:
```bash
pytest tests/
```

### Integration Tests

Test webhooks locally:
```bash
# Start server
uvicorn app.main:app

# In another terminal
curl -X POST http://localhost:8000/webhook/twilio-voice \
  -d "SpeechResult=test command"
```

---

## Deployment

See [Deployment Guide](DEPLOYMENT_GUIDE.md) for full deployment instructions.
