import json
import logging
from typing import List

logger = logging.getLogger(__name__)

MOCK_RECIPES = {
    "eggs": {
        "microwave": {
            "title": "Microwave Scrambled Eggs",
            "description": "Quick and easy scrambled eggs made in the microwave",
            "steps": [
                {
                    "step_number": 1,
                    "instruction": "Crack eggs into a microwave-safe bowl",
                    "duration_minutes": 1
                },
                {
                    "step_number": 2,
                    "instruction": "Beat eggs with a fork until well mixed",
                    "duration_minutes": 1
                },
                {
                    "step_number": 3,
                    "instruction": "Microwave on high for 2 minutes, stirring every 30 seconds",
                    "duration_minutes": 2
                },
                {
                    "step_number": 4,
                    "instruction": "Let cool for 1 minute and serve",
                    "duration_minutes": 1
                }
            ],
            "time_minutes": 5,
            "difficulty": "easy",
            "servings": 1,
            "notes": "Use medium power if available to prevent overcooking"
        }
    },
    "bread": {
        "toaster": {
            "title": "Perfect Golden Toast",
            "description": "Crispy toast with a golden brown exterior",
            "steps": [
                {
                    "step_number": 1,
                    "instruction": "Place bread slice in toaster",
                    "duration_minutes": 1
                },
                {
                    "step_number": 2,
                    "instruction": "Set toaster to medium setting (level 5)",
                    "duration_minutes": 1
                },
                {
                    "step_number": 3,
                    "instruction": "Press down lever and wait until toast pops",
                    "duration_minutes": 3
                }
            ],
            "time_minutes": 5,
            "difficulty": "easy",
            "servings": 1,
            "notes": "Adjust toaster level based on preference for crispiness"
        }
    }
}


class MockLLMService:
    """Mock LLM service for testing without API key"""

    async def generate(self, ingredients: List[str], appliance: str) -> dict:
        """Generate mock recipe based on ingredients and appliance"""
        
        # Try to find a matching mock recipe
        for ingredient in ingredients:
            ingredient_lower = ingredient.lower()
            if ingredient_lower in MOCK_RECIPES:
                appliance_lower = appliance.lower()
                if appliance_lower in MOCK_RECIPES[ingredient_lower]:
                    recipe = MOCK_RECIPES[ingredient_lower][appliance_lower].copy()
                    logger.info(f"Mock recipe generated: {recipe.get('title')}")
                    return recipe

        # Fallback: generic recipe
        recipe = {
            "title": f"Mixed {appliance.title()} Recipe",
            "description": f"A quick recipe using {', '.join(ingredients[:2])} in a {appliance}",
            "steps": [
                {
                    "step_number": 1,
                    "instruction": f"Prepare ingredients: {', '.join(ingredients)}",
                    "duration_minutes": 5
                },
                {
                    "step_number": 2,
                    "instruction": f"Cook using {appliance} on medium heat/setting",
                    "duration_minutes": 10
                },
                {
                    "step_number": 3,
                    "instruction": "Serve when done",
                    "duration_minutes": 2
                }
            ],
            "time_minutes": 17,
            "difficulty": "easy",
            "servings": 1,
            "notes": "This is a mock recipe for testing purposes"
        }
        logger.info(f"Mock recipe generated: {recipe.get('title')}")
        return recipe
