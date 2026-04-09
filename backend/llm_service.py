"""LLM Service using Qwen CLI - Direct integration"""
import logging
import asyncio
import json
import re
from typing import List

logger = logging.getLogger(__name__)

class LLMService:
    """Service for recipe generation using Qwen CLI"""
    def __init__(self):
        self.timeout = 60
        logger.info("✅ LLMService initialized: Real Qwen CLI")

    async def generate(self, ingredients: List[str], appliances: List[str]) -> dict:
        """Generate recipe using Qwen CLI"""
        try:
            ingredients_str = ", ".join(ingredients)
            appliances_str = ", ".join(appliances)
            
            prompt = f"""You are a dorm cooking expert. Generate JSON recipe using only: {ingredients_str} and {appliances_str}
Return ONLY valid JSON:
{{"title":"Recipe","description":"Dish","servings":2,"time_minutes":30,"difficulty":"easy","steps":[{{"step_number":1,"instruction":"Cook","duration_minutes":30}}],"notes":"Enjoy"}}"""
            
            logger.info(f"🍳 Calling Qwen: {ingredients_str}")
            process = await asyncio.create_subprocess_shell(
                f'/usr/bin/qwen --output-format json "{prompt}"',
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE
            )
            
            stdout, stderr = await asyncio.wait_for(
                process.communicate(),
                timeout=self.timeout
            )
            
            if process.returncode != 0:
                raise Exception(f"Qwen error: {stderr.decode()}")
            
            output = stdout.decode('utf-8', errors='ignore')
            logger.info(f"📝 Output: {output[:100]}")
            
            try:
                recipe = json.loads(output)
            except json.JSONDecodeError:
                json_match = re.search(r'\{.*\}', output, re.DOTALL)
                if json_match:
                    recipe = json.loads(json_match.group())
                else:
                    raise ValueError("No JSON in response")
            
            recipe.setdefault('title', f"Creative {ingredients_str}")
            recipe.setdefault('description', f"Dorm meal with {ingredients_str}")
            recipe.setdefault('servings', 2)
            recipe.setdefault('time_minutes', 30)
            recipe.setdefault('difficulty', 'easy')
            recipe.setdefault('steps', [])
            recipe.setdefault('notes', 'Enjoy!')
            
            logger.info(f"✅ Recipe: {recipe.get('title')}")
            return recipe
        except asyncio.TimeoutError:
            raise Exception("Timeout")
        except Exception as e:
            logger.error(f"❌ Error: {str(e)}")
            raise
