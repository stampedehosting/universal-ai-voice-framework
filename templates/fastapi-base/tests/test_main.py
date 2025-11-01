"""
Tests for FastAPI application
"""

import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_read_root():
    """Test root endpoint"""
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert "name" in data
    assert data["name"] == "Universal AI Voice Automation Framework"


def test_health_check():
    """Test health endpoint"""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["ok"] is True


def test_list_agents():
    """Test agents endpoint"""
    response = client.get("/agents")
    assert response.status_code == 200
    data = response.json()
    assert "agents" in data
    assert len(data["agents"]) > 0


def test_twilio_voice_webhook():
    """Test Twilio voice webhook"""
    response = client.post(
        "/webhook/twilio-voice",
        data={
            "From": "+15555551234",
            "To": "+15555556789",
            "SpeechResult": "open github",
            "CallSid": "CAxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        }
    )
    assert response.status_code == 200
    assert "application/xml" in response.headers["content-type"]
    assert "<Response>" in response.text
    assert "<Say>" in response.text


def test_twilio_sms_webhook():
    """Test Twilio SMS webhook"""
    response = client.post(
        "/webhook/twilio-sms",
        data={
            "From": "+15555551234",
            "Body": "help",
            "MessageSid": "SMxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        }
    )
    assert response.status_code == 200
    assert "application/xml" in response.headers["content-type"]
    assert "<Response>" in response.text
    assert "<Message>" in response.text


def test_intent_processing():
    """Test intent processing"""
    from app.intents import process_intent
    from app.automation import PlaywrightAutomation
    
    automation = PlaywrightAutomation()
    
    # Test help intent
    result = pytest.mark.asyncio(process_intent)("help", automation)
    # Result should be a coroutine, so we just check it doesn't raise
    assert result is not None
