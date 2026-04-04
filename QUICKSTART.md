# DormChef v1.0 - Quick Start Guide

## Overview
DormChef is an AI-powered recipe generator for dorm students. It creates recipes using ONLY your available ingredients and a single kitchen appliance.

## What Works ✅
- **Recipe Generation**: AI generates step-by-step recipes from ingredients + appliance
- **Recipe History**: All generated recipes saved to database with timestamps
- **Web Interface**: Single-page app at http://localhost:8000
- **Mock Fallback**: If LLM fails, uses pre-made recipes (no downtime)
- **Responsive UI**: Works on desktop and mobile

## Installation (Ubuntu 24.04)

### Option A: Automated (Recommended)
```bash
git clone https://github.com/egg1245/Lab9.git se-toolkit-hackathon
cd se-toolkit-hackathon

# One-time setup
bash setup.sh

# Start services
bash start.sh

# In another terminal, test
bash test.sh
```

**Expected output from test.sh:**
```
✓ PASS (Health Check)
✓ PASS - Title: [Recipe Name]
✓ PASS - Recipes: [N]
✅ All tests passed!
```

### Option B: Manual
```bash
git clone https://github.com/egg1245/Lab9.git
cd se-toolkit-hackathon

# Setup
python3 -m venv venv
source venv/bin/activate
pip install -r backend/requirements.txt

# Start DB (in one terminal)
docker run -d --name dormchef-db \
  -e POSTGRES_PASSWORD=dormchef \
  -p 5432:5432 \
  postgres:16-alpine

# Start backend (in another terminal)
cd backend
python -m uvicorn main:app --reload
```

## Usage

### Web Browser
1. Open **http://localhost:8000**
2. Enter ingredients (comma-separated, e.g., "eggs, bread, butter")
3. Select appliance (Microwave, Toaster, etc.)
4. Click **"Generate Recipe ✨"**
5. View recipe with steps, timing, difficulty
6. Browse recipe history below

### API Direct Testing
```bash
# Generate recipe
curl -X POST http://localhost:8000/api/generate \
  -H "Content-Type: application/json" \
  -d '{"ingredients": ["eggs", "bread"], "appliance": "microwave"}'

# Get history
curl http://localhost:8000/api/recipes

# Health check
curl http://localhost:8000/health
```

## Configuration

### Set OpenAI/OpenRouter API Key (Optional)
```bash
# Edit .env file
export OPENAI_API_KEY="sk-or-v1-YOUR_KEY_HERE"
export OPENAI_API_BASE="https://openrouter.ai/api/v1"
```

**Without API key:** System uses built-in mock recipes (fully functional!)

### Environment Variables
```bash
# .env file
OPENAI_API_KEY=sk-or-v1-...           # Optional: LLM API key
DATABASE_URL=postgresql+asyncpg://... # DB connection (auto-configured)
LLM_MODEL=openrouter/qwen/...        # Model to use
POSTGRES_PASSWORD=dormchef            # DB password
```

## Troubleshooting

### Port 8000 already in use
```bash
# Kill existing process
sudo fuser -k 8000/tcp

# Or find and kill manually
lsof -i :8000
kill -9 [PID]

# Restart
bash start.sh
```

### PostgreSQL connection errors
```bash
# Check if container is running
docker ps | grep dormchef-db

# View logs
docker logs dormchef-db

# Restart container
docker restart dormchef-db
```

### LLM errors / slow generation
- System automatically falls back to mock recipes
- Check `.env` for valid API key
- LLM calls timeout after 30 seconds

## Architecture

```
┌─────────────┐
│  Frontend   │ (index.html - Vanilla JS/Tailwind)
├─────────────┤
│  FastAPI    │ (backend/main.py - async routes)
├─────────────┤
│ PostgreSQL  │ (Docker container)
└─────────────┘
      ↓
   OpenRouter API (Qwen model)
      ↓
   Mock Service (fallback)
```

## Project Files

| File | Purpose |
|------|---------|
| `backend/main.py` | FastAPI routes and app logic |
| `backend/models.py` | Pydantic request/response schemas |
| `backend/database.py` | PostgreSQL ORM and migrations |
| `backend/llm_service.py` | LLM integration (OpenRouter, mock fallback) |
| `frontend/index.html` | Single-page web app |
| `.env.example` | Environment template |
| `test.sh` | Automated test suite |
| `start.sh` | Service startup script |
| `setup.sh` | Dependency installation |

## For TAs / Evaluators

### Quick Validation
```bash
# 1. Start services
bash start.sh &

# 2. Wait ~5 seconds, then run tests
bash test.sh

# 3. Open browser to http://localhost:8000
# 4. Try generating a recipe with: eggs, bread | microwave
```

### Expected Results
- ✅ Health check responds instantly
- ✅ Recipe generated in <35 seconds
- ✅ Recipe displays title, difficulty, timing, steps
- ✅ Recipe history populated after generation
- ✅ Frontend UI responsive and interactive

### Test Example Ingredients
```
eggs, bread, butter        → Toaster
rice, water                → Microwave
pasta, tomato, salt        → Hot plate
```

## Development

### Local Testing (No Docker)
```bash
# Terminal 1: Start DB in Docker
docker run -p 5432:5432 postgres:16-alpine

# Terminal 2: Run backend
cd backend
export DATABASE_URL="postgresql+asyncpg://dormchef:dormchef@127.0.0.1:5432/dormchef"
python -m uvicorn main:app --reload

# Terminal 3: Test
curl http://localhost:8000/health
```

### Running Tests
```bash
cd backend
pytest
```

## Version 1 Features (Completed)
- ✅ Recipe generation via LLM (Qwen model via OpenRouter)
- ✅ PostgreSQL database with recipe history
- ✅ Web UI with ingredient form and appliance selector
- ✅ Mock service fallback (no API key required)
- ✅ Async FastAPI backend
- ✅ Docker PostgreSQL container
- ✅ Comprehensive test suite
- ✅ Error handling and validation

## Version 2 Roadmap (Future)
- 📋 User authentication and saved favorites
- 📋 Recipe ratings and community features
- 📋 Advanced filters (difficulty, cooking time, cuisine)
- 📋 Export to PDF/print
- 📋 Mobile app
- 📋 Ingredient substitution suggestions

## Support

**Issues?** Check `.env` configuration and logs:
```bash
# Backend logs
tail -f backend.log

# Database logs
docker logs dormchef-db

# Test endpoint manually
curl -v http://localhost:8000/health
```

**Code repository:** https://github.com/egg1245/Lab9

---

**Built for Lab 9 Hackathon - Software Engineering Toolkit**  
Version 1.0 | April 2026
