import os
from sqlalchemy import create_engine, Column, Integer, String, JSON, DateTime, ARRAY, MetaData, Table
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import declarative_base, sessionmaker
from datetime import datetime
import logging

logger = logging.getLogger(__name__)

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql+asyncpg://dormchef:dormchef@localhost:5432/dormchef")

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


class Recipe(Base):
    """Recipe ORM model"""
    __tablename__ = "recipes"

    id = Column(Integer, primary_key=True, index=True)
    ingredients = Column(ARRAY(String), nullable=False)
    appliance = Column(String(100), nullable=False)
    content = Column(JSON, nullable=False)  # Full recipe from LLM
    created_at = Column(DateTime, default=datetime.utcnow, index=True)


async def get_db():
    """Dependency for FastAPI routes to get DB session"""
    async with AsyncSessionLocal() as session:
        yield session


async def init_db():
    """Initialize database tables"""
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    logger.info("Database initialized")


async def close_db():
    """Close database connection"""
    await engine.dispose()
