# Universal AI Voice Automation System Builder

## 🚀 Your Mission

Your task is to build a complete, production-ready AI voice automation system using the **Universal AI Voice Automation Framework**. You will be given specific project requirements, and you must generate the necessary code, configurations, and deployment steps based on the provided template.

---

## 🏗️ Core Architecture

All systems are built on a standardized, robust architecture:

- **Backend**: FastAPI (Python) or Express (Node.js)
- **Telephony**: Twilio (Voice & SMS)
- **AI Voice**: ElevenLabs (100+ pre-configured agents)
- **Browser Automation**: Playwright
- **Public Access**: Cloudflare Tunnel
- **Email**: Amazon SES
- **Storage**: Amazon S3, Google Drive, Trello, Go High Level
- **Deployment**: Docker, Terraform, Ansible

---

## 📋 Project Specifications

**This section will be filled in for each new project.**

- **Project Name**: `{PROJECT_NAME}`
- **Primary Domain**: `{DOMAIN}`
- **Selected Agents**: `{AGENT_LIST}`
- **Core Use Case**: `{USE_CASE_DESCRIPTION}`
- **Custom Intents**: `{CUSTOM_INTENTS_LIST}`

---

## 📝 Your Instructions

### 1. Initialize the Project

Start with the base template located at `templates/fastapi-base/`.

### 2. Implement Custom Logic

Based on the `{USE_CASE_DESCRIPTION}` and `{CUSTOM_INTENTS_LIST}`, you must modify the following files:

#### `app/intents.py`
- Create new `@intent_handler` functions for each custom intent.
- Map natural language phrases to these functions.
- Call the appropriate Playwright automation tasks.

**Example:**
```python
@intent_handler("search for grants")
async def search_for_grants(transcript: str, auto: PlaywrightAuto):
    query = extract_query(transcript)
    await auto.search_grants(query)
```

#### `app/automation.py`
- Implement the browser automation logic for each intent.
- Use Playwright to navigate pages, fill forms, and extract data.

**Example:**
```python
async def search_grants(self, query: str):
    await self.page.goto("https://grants.gov")
    await self.page.locator("#keywords").fill(query)
    await self.page.locator("button[type='submit']").click()
    # ... logic to scrape results
```

### 3. Configure Agent Routing

In `app/elevenlabs.py`, you can define rules to route incoming calls to specific agents based on:
- Caller ID
- Time of day
- Domain

### 4. Set Up Email Templates

In `app/ses_email.py`, create templates for follow-up emails sent via Amazon SES.

---

## 🔐 API Keys & Environment

- **You do not need to ask for API keys.**
- All necessary API keys for Twilio, ElevenLabs, AWS, Cloudflare, etc., are pre-configured in an encrypted vault.
- They will be automatically injected into the `.env` file during the automated deployment process.

---

## 📜 Custom Requirements Section

**This is where the user's specific transcript or instructions will be pasted.**

```
{TRANSCRIPT_OR_REQUIREMENTS}
```

**Your task is to parse the text above to determine the `{USE_CASE_DESCRIPTION}` and `{CUSTOM_INTENTS_LIST}`.**

---

## 🚀 Deployment

- The framework includes a one-click deployment script (`./deploy.sh`).
- This script handles:
  1. Provisioning a VPS (AWS or DigitalOcean)
  2. Configuring the Cloudflare Tunnel and DNS
  3. Deploying the application using Docker
  4. Setting up Twilio webhooks
- You do not need to write deployment scripts, but you should be aware of the process.

---

## ✅ Success Criteria

A successful build means:

1.  The application code is generated correctly based on the requirements.
2.  New intents are defined in `app/intents.py`.
3.  New Playwright automation is implemented in `app/automation.py`.
4.  The code is clean, efficient, and follows the framework's structure.
5.  The system is ready for one-click deployment via `./deploy.sh`.

---

## 💡 Example Task

**If the user provides:**
> "I need a system to help me book flights. It should ask for my destination and dates, search on Google Flights, and show me the top 3 options. Deploy it on flightbooker.ai."

**You should:**

1.  **Parse Requirements:**
    -   `PROJECT_NAME`: "flight-booker"
    -   `DOMAIN`: "flightbooker.ai"
    -   `USE_CASE`: Flight booking assistant
    -   `CUSTOM_INTENTS`: `search_flights`, `select_option`

2.  **Generate Code:**
    -   In `intents.py`, create `@intent_handler("search for flights")`.
    -   In `automation.py`, create `async def search_flights(self, destination, date):` that goes to Google Flights and performs the search.

---

**You are now ready to receive the project specifications. Begin by analyzing the user's requirements and then generate the necessary code within the framework.**

