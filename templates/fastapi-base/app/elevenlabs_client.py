"""
ElevenLabs client for conversational AI
"""

import os
from typing import Optional


class ElevenLabsClient:
    """Client for ElevenLabs conversational AI"""
    
    def __init__(self, api_key: str, default_agent: str):
        self.api_key = api_key
        self.default_agent = default_agent
    
    async def get_agent_response(self, text: str, agent_id: Optional[str] = None) -> str:
        """
        Get response from ElevenLabs agent
        
        Args:
            text: Input text
            agent_id: Optional agent ID, uses default if not provided
            
        Returns:
            Response text from agent
        """
        # In production, this would call the ElevenLabs API
        # For now, return a simple echo response
        agent = agent_id or self.default_agent
        return f"Agent {agent} received: {text}"
    
    def list_agents(self):
        """List available agents"""
        return [
            {"name": "Noble", "id": "agent_noble"},
            {"name": "GrantExpert", "id": "agent_grant_expert"},
            {"name": "SupportAgent", "id": "agent_support"}
        ]
