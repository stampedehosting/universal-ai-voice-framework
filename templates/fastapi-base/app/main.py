from fastapi import FastAPI, Request, Form
from fastapi.responses import Response
import os
from typing import Optional

from .intents import process_intent
from .elevenlabs_client import ElevenLabsClient
from .automation import PlaywrightAutomation

app = FastAPI(title="Universal AI Voice Automation")

# Initialize clients
elevenlabs_client = ElevenLabsClient(
    api_key=os.getenv("ELEVENLABS_API_KEY", ""),
    default_agent=os.getenv("ELEVENLABS_DEFAULT_AGENT", "")
)

playwright_auto = PlaywrightAutomation()


@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "name": "Universal AI Voice Automation Framework",
        "version": "1.0.0",
        "status": "running"
    }


@app.get("/health")
async def health():
    """Health check endpoint"""
    return {"ok": True}


@app.get("/agents")
async def list_agents():
    """List available ElevenLabs agents"""
    return {
        "agents": [
            {"name": "Noble", "id": "agent_noble"},
            {"name": "GrantExpert", "id": "agent_grant_expert"},
            {"name": "SupportAgent", "id": "agent_support"}
        ]
    }


@app.post("/webhook/twilio-voice")
async def twilio_voice_webhook(
    request: Request,
    From: Optional[str] = Form(None),
    To: Optional[str] = Form(None),
    SpeechResult: Optional[str] = Form(None),
    CallSid: Optional[str] = Form(None)
):
    """
    Twilio voice webhook endpoint
    Receives voice input and processes intents
    """
    # Get speech result
    speech_text = SpeechResult or ""
    
    # Process intent
    if speech_text:
        response_text = await process_intent(speech_text, playwright_auto)
    else:
        response_text = "Hello! I'm your AI assistant. How can I help you today?"
    
    # Generate TwiML response
    twiml = f"""<?xml version="1.0" encoding="UTF-8"?>
<Response>
    <Say>{response_text}</Say>
    <Gather input="speech" timeout="3" action="/webhook/twilio-voice">
        <Say>Please tell me what you'd like me to do.</Say>
    </Gather>
</Response>"""
    
    return Response(content=twiml, media_type="application/xml")


@app.post("/webhook/twilio-sms")
async def twilio_sms_webhook(
    request: Request,
    From: Optional[str] = Form(None),
    Body: Optional[str] = Form(None),
    MessageSid: Optional[str] = Form(None)
):
    """
    Twilio SMS webhook endpoint
    Receives SMS and processes intents
    """
    message_body = Body or ""
    
    # Process intent
    if message_body:
        response_text = await process_intent(message_body, playwright_auto)
    else:
        response_text = "Hello! Send me a message with what you'd like me to do."
    
    # Generate TwiML response
    twiml = f"""<?xml version="1.0" encoding="UTF-8"?>
<Response>
    <Message>{response_text}</Message>
</Response>"""
    
    return Response(content=twiml, media_type="application/xml")


@app.on_event("startup")
async def startup_event():
    """Initialize on startup"""
    await playwright_auto.initialize()


@app.on_event("shutdown")
async def shutdown_event():
    """Cleanup on shutdown"""
    await playwright_auto.close()
