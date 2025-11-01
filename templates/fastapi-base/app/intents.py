"""
Intent processing module
Maps natural language to actions
"""

from typing import Dict, Callable, Any
import re

# Intent handlers registry
intent_handlers: Dict[str, Callable] = {}


def intent_handler(pattern: str):
    """Decorator to register intent handlers"""
    def decorator(func: Callable):
        intent_handlers[pattern] = func
        return func
    return decorator


async def process_intent(text: str, automation) -> str:
    """
    Process user intent from text
    Returns response text
    """
    text_lower = text.lower().strip()
    
    # Check each registered intent
    for pattern, handler in intent_handlers.items():
        if re.search(pattern, text_lower, re.IGNORECASE):
            try:
                return await handler(text, automation)
            except Exception as e:
                return f"I encountered an error: {str(e)}"
    
    # Default response if no intent matched
    return "I'm not sure how to help with that. Try asking me to open a website or search for something."


# Built-in intent handlers

@intent_handler(r"open|go to|navigate to")
async def handle_open_website(text: str, automation) -> str:
    """Handle opening websites"""
    # Extract URL or site name
    words = text.lower().split()
    
    # Common sites
    site_map = {
        "github": "https://github.com",
        "google": "https://google.com",
        "youtube": "https://youtube.com",
        "twitter": "https://twitter.com",
        "facebook": "https://facebook.com"
    }
    
    for site, url in site_map.items():
        if site in text.lower():
            await automation.navigate_to(url)
            return f"Opening {site} for you."
    
    return "Which website would you like me to open?"


@intent_handler(r"search for|find|look for")
async def handle_search(text: str, automation) -> str:
    """Handle search queries"""
    # Extract search query
    query = text.lower()
    for prefix in ["search for", "find", "look for"]:
        if prefix in query:
            query = query.split(prefix, 1)[1].strip()
            break
    
    await automation.search_google(query)
    return f"Searching for {query}"


@intent_handler(r"help|what can you do")
async def handle_help(text: str, automation) -> str:
    """Provide help information"""
    return """I can help you with:
- Opening websites (say 'open GitHub')
- Searching for information (say 'search for grants')
- And more custom actions based on your configuration"""
