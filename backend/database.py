import os
from sqlalchemy import Column, Integer, String, JSON, DateTime, ARRAY, Table, ForeignKey
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import declarative_base, sessionmaker, relationship
from datetime import datetime
import logging

logger = logging.getLogger(__name__)

# Use localhost for local Python backend connecting to Docker postgres
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql+asyncpg://dormchef:dormchef@127.0.0.1:5432/dormchef"
)

engine = create_async_engine(
    DATABASE_URL,
    echo=False,
    pool_size=20,
    max_overflow=40,
)

AsyncSessionLocal = sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autocommit=False,
    autoflush=False,
)

Base = declarative_base()

# Association table for many-to-many relationship between recipes and appliances
recipe_appliances = Table(
    'recipe_appliances',
    Base.metadata,
    Column('recipe_id', Integer, ForeignKey('recipes.id', ondelete='CASCADE'), primary_key=True),
    Column('appliance_id', Integer, ForeignKey('appliances.id', ondelete='CASCADE'), primary_key=True)
)


class Appliance(Base):
    """Kitchen appliance model"""
    __tablename__ = "appliances"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), unique=True, nullable=False)
    description = Column(String(500), nullable=True)
    is_default = Column(Integer, default=0)  # 1 for default/built-in, 0 for user-created
    created_at = Column(DateTime, default=datetime.utcnow, index=True)

    recipes = relationship("Recipe", secondary=recipe_appliances, back_populates="appliances")


class Recipe(Base):
    """Recipe ORM model"""
    __tablename__ = "recipes"

    id = Column(Integer, primary_key=True, index=True)
    ingredients = Column(ARRAY(String), nullable=False)
    content = Column(JSON, nullable=False)  # Full recipe from LLM
    created_at = Column(DateTime, default=datetime.utcnow, index=True)

    appliances = relationship("Appliance", secondary=recipe_appliances, back_populates="recipes")


async def get_db():
    """Dependency for FastAPI routes to get DB session"""
    async with AsyncSessionLocal() as session:
        yield session


async def init_db():
    """Initialize database tables and seed default appliances"""
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    
    # Seed default appliances
    async with AsyncSessionLocal() as session:
        # Check if appliances already exist
        from sqlalchemy import select
        result = await session.execute(select(Appliance).limit(1))
        if result.scalars().first() is None:
            default_appliances = [
                Appliance(name="Microwave", description="Microwave oven", is_default=1),
                Appliance(name="Toaster", description="Bread toaster", is_default=1),
                Appliance(name="Hot Plate", description="Portable cooking plate", is_default=1),
                Appliance(name="Air Fryer", description="Electric air fryer", is_default=1),
                Appliance(name="Oven", description="Electric oven", is_default=1),
                Appliance(name="Blender", description="Food blender", is_default=1),
            ]
            session.add_all(default_appliances)
            await session.commit()
            logger.info("Default appliances seeded")
    
    logger.info("Database initialized")


async def close_db():
    """Close database connection"""
    await engine.dispose()
