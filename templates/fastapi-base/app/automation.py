"""
Playwright browser automation
"""

from playwright.async_api import async_playwright, Browser, Page
from typing import Optional


class PlaywrightAutomation:
    """Browser automation using Playwright"""
    
    def __init__(self):
        self.playwright = None
        self.browser: Optional[Browser] = None
        self.page: Optional[Page] = None
    
    async def initialize(self):
        """Initialize Playwright and browser"""
        self.playwright = await async_playwright().start()
        self.browser = await self.playwright.chromium.launch(headless=True)
        self.page = await self.browser.new_page()
    
    async def close(self):
        """Close browser and Playwright"""
        if self.page:
            await self.page.close()
        if self.browser:
            await self.browser.close()
        if self.playwright:
            await self.playwright.stop()
    
    async def navigate_to(self, url: str):
        """Navigate to a URL"""
        if not self.page:
            await self.initialize()
        await self.page.goto(url)
    
    async def search_google(self, query: str):
        """Search on Google"""
        if not self.page:
            await self.initialize()
        
        await self.page.goto("https://www.google.com")
        await self.page.fill('textarea[name="q"]', query)
        await self.page.press('textarea[name="q"]', 'Enter')
        await self.page.wait_for_load_state('networkidle')
    
    async def search_grants(self, query: str):
        """Search for grants on grants.gov"""
        if not self.page:
            await self.initialize()
        
        await self.page.goto("https://www.grants.gov/search-grants.html")
        # Wait for page to load
        await self.page.wait_for_load_state('networkidle')
        
        # Fill in search form
        try:
            await self.page.fill('input[name="keywords"]', query)
            await self.page.click('button[type="submit"]')
            await self.page.wait_for_load_state('networkidle')
        except Exception as e:
            print(f"Error searching grants: {e}")
    
    async def click_element(self, selector: str):
        """Click an element by selector"""
        if not self.page:
            await self.initialize()
        await self.page.click(selector)
    
    async def type_text(self, selector: str, text: str):
        """Type text into an element"""
        if not self.page:
            await self.initialize()
        await self.page.fill(selector, text)
    
    async def get_text(self, selector: str) -> str:
        """Get text from an element"""
        if not self.page:
            await self.initialize()
        return await self.page.text_content(selector) or ""
    
    async def screenshot(self, path: str):
        """Take a screenshot"""
        if not self.page:
            await self.initialize()
        await self.page.screenshot(path=path)
