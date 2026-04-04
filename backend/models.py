from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime


class RecipeRequest(BaseModel):
    """Request model for recipe generation"""
    ingredients: List[str] = Field(..., min_items=1, description="List of available ingredients")
    appliance: str = Field(..., min_length=1, description="Kitchen appliance to use")


class RecipeStep(BaseModel):
    """Single step in a recipe"""
    step_number: int
    instruction: str
    duration_minutes: Optional[int] = None


class RecipeContent(BaseModel):
    """Recipe content returned from LLM"""
    title: str
    description: Optional[str] = None
    steps: List[RecipeStep]
    time_minutes: int
    difficulty: str = Field(..., pattern="^(easy|medium|hard)$")
    servings: int = 1
    notes: Optional[str] = None


class RecipeResponse(BaseModel):
    """Response model for generated recipe"""
    id: int
    ingredients: List[str]
    appliance: str
    content: RecipeContent
    created_at: datetime

    class Config:
        from_attributes = True


class RecipeDB(BaseModel):
    """Database model for recipes"""
    id: Optional[int] = None
    ingredients: List[str]
    appliance: str
    content: dict  # JSON stored in DB
    created_at: Optional[datetime] = None
