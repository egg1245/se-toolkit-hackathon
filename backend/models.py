from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime


class RecipeRequest(BaseModel):
    """Request model for recipe generation"""
    ingredients: List[str] = Field(..., min_items=1, description="List of available ingredients")
    appliance_ids: List[int] = Field(..., min_items=1, description="List of appliance IDs to use")


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


class ApplianceBase(BaseModel):
    """Base appliance model"""
    name: str = Field(..., min_length=1, max_length=100)
    description: Optional[str] = Field(None, max_length=500)


class ApplianceCreate(ApplianceBase):
    """Create appliance request"""
    pass


class ApplianceUpdate(BaseModel):
    """Update appliance request"""
    name: Optional[str] = Field(None, min_length=1, max_length=100)
    description: Optional[str] = Field(None, max_length=500)


class ApplianceResponse(ApplianceBase):
    """Appliance response"""
    id: int
    is_default: int
    created_at: datetime

    class Config:
        from_attributes = True


class RecipeResponse(BaseModel):
    """Response model for generated recipe"""
    id: int
    ingredients: List[str]
    appliances: List[ApplianceResponse]
    content: RecipeContent
    created_at: datetime

    class Config:
        from_attributes = True


class RecipeDB(BaseModel):
    """Database model for recipes"""
    id: Optional[int] = None
    ingredients: List[str]
    appliances: List[ApplianceResponse] = []
    content: dict  # JSON stored in DB
    created_at: Optional[datetime] = None
