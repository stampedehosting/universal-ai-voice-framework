# Grant Assistant Example

This example demonstrates building a grant assistance bot using the Universal AI Voice Automation Framework.

## Overview

The Grant Assistant helps nonprofits:
- Search for relevant grants on grants.gov
- Extract grant details and requirements
- Send follow-up emails with grant information
- Schedule application reminders

## Features

- Voice-activated grant search
- Automated form filling
- Email notifications via Amazon SES
- Integration with Trello for tracking

## Setup

1. **Deploy the application:**
   ```bash
   cd /path/to/universal-ai-voice-framework
   
   ./deploy.sh \
     --name "grant-assistant" \
     --domain "granthelp.ai" \
     --use-case "grant assistance" \
     --agents "Noble,GrantExpert"
   ```

2. **Customize intents:**
   
   Edit `app/intents.py` to add grant-specific intents:
   ```python
   @intent_handler(r"search for grants|find grants|look for funding")
   async def search_grants(text: str, automation) -> str:
       """Search for grants"""
       query = extract_query(text)
       await automation.search_grants(query)
       
       # Get results
       results = await automation.get_grant_results()
       
       # Send email with results
       await send_grant_results_email(results)
       
       return f"I found {len(results)} grants. Check your email for details."
   ```

3. **Add custom automation:**
   
   Edit `app/automation.py`:
   ```python
   async def get_grant_results(self):
       """Extract grant search results"""
       results = []
       
       # Wait for results to load
       await self.page.wait_for_selector(".grant-result")
       
       # Extract each result
       elements = await self.page.query_selector_all(".grant-result")
       
       for element in elements[:5]:  # Get top 5
           title = await element.query_selector(".title")
           amount = await element.query_selector(".amount")
           deadline = await element.query_selector(".deadline")
           
           results.append({
               "title": await title.inner_text() if title else "",
               "amount": await amount.inner_text() if amount else "",
               "deadline": await deadline.inner_text() if deadline else ""
           })
       
       return results
   ```

## Usage

### Call your Twilio number and say:

- "Search for grants for education nonprofits"
- "Find funding for environmental projects"
- "Look for grants with deadlines next month"

### The bot will:

1. Search grants.gov
2. Extract top matching grants
3. Send you an email with:
   - Grant titles
   - Award amounts
   - Deadlines
   - Application links

## Email Template

Create `app/templates/grant_results.html`:

```html
<!DOCTYPE html>
<html>
<head>
    <style>
        .grant { margin: 20px 0; padding: 15px; border: 1px solid #ddd; }
        .title { font-size: 18px; font-weight: bold; }
        .amount { color: green; font-size: 16px; }
        .deadline { color: red; }
    </style>
</head>
<body>
    <h1>Grant Search Results</h1>
    {% for grant in grants %}
    <div class="grant">
        <div class="title">{{ grant.title }}</div>
        <div class="amount">Amount: {{ grant.amount }}</div>
        <div class="deadline">Deadline: {{ grant.deadline }}</div>
        <a href="{{ grant.link }}">View Details</a>
    </div>
    {% endfor %}
</body>
</html>
```

## Advanced Features

### Trello Integration

Track grants in Trello:

```python
async def add_to_trello(grant):
    """Add grant to Trello board"""
    import requests
    
    url = f"https://api.trello.com/1/cards"
    params = {
        "key": os.getenv("TRELLO_API_KEY"),
        "token": os.getenv("TRELLO_TOKEN"),
        "idList": os.getenv("TRELLO_LIST_ID"),
        "name": grant["title"],
        "desc": f"Amount: {grant['amount']}\nDeadline: {grant['deadline']}"
    }
    
    response = requests.post(url, params=params)
    return response.json()
```

### Calendar Integration

Add deadlines to Google Calendar:

```python
from google.oauth2 import service_account
from googleapiclient.discovery import build

async def add_to_calendar(grant):
    """Add grant deadline to Google Calendar"""
    credentials = service_account.Credentials.from_service_account_file(
        'credentials.json'
    )
    service = build('calendar', 'v3', credentials=credentials)
    
    event = {
        'summary': f"Grant Deadline: {grant['title']}",
        'description': f"Amount: {grant['amount']}",
        'start': {'date': grant['deadline']},
        'end': {'date': grant['deadline']}
    }
    
    service.events().insert(calendarId='primary', body=event).execute()
```

## Environment Variables

Add to `.env`:

```bash
# Trello
TRELLO_API_KEY=your_trello_api_key
TRELLO_TOKEN=your_trello_token
TRELLO_LIST_ID=your_list_id

# Google Calendar (optional)
GOOGLE_CALENDAR_CREDENTIALS=path/to/credentials.json
```

## Testing

Test locally:

```bash
# Start server
docker-compose up

# Test grant search webhook
curl -X POST http://localhost:3001/webhook/twilio-voice \
  -d "SpeechResult=search for grants for nonprofits"
```

## Deployment

Deploy to production:

```bash
./deploy.sh \
  --name "grant-assistant" \
  --domain "granthelp.ai" \
  --template "fastapi-base"
```

## Support

For issues or questions:
- GitHub Issues: https://github.com/stampedehosting/universal-ai-voice-framework/issues
- Email: stampedehosting@gmail.com
