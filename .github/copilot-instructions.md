# DormChef: AI Coding Agent Instructions

## Project Overview
**DormChef** is a full-stack web application that generates personalized recipes based on user-provided ingredients and kitchen appliances, leveraging LLM agents to solve the dorm cooking problem.

**Stack:** FastAPI (Backend) | PostgreSQL (Database) | Vanilla JS/HTML/Tailwind (Frontend)  
**Deployment:** Docker + docker-compose (Ubuntu 24.04)  
**Repository:** `se-toolkit-hackathon`

---

## Architecture & Data Flow

### Big Picture
```
Frontend (Vanilla JS/Tailwind) 
    ↓
FastAPI Backend (REST API)
    ↓
LLM Service (OpenAI/Local)
    ↓
PostgreSQL Database
```

**Key Components:**
- **Frontend** (`/frontend`): Single-page app; sends `{ingredients: [], appliance: string}` to backend
- **Backend** (`/backend`): FastAPI routes for recipe generation and history retrieval
- **Database** (`/database`): PostgreSQL with `recipes` table (id, ingredients, appliance, content, created_at)
- **LLM Integration**: Calls external LLM with system prompt specifying recipe format

### Critical Data Flows
1. **Recipe Generation**: User input → Backend validates → LLM called with system prompt → Response saved to DB → Returned to frontend
2. **Recipe History**: Frontend requests `/api/recipes` → Backend queries PostgreSQL → Returns paginated list sorted by date

---

## Version Phases & Deliverables

### Phase 1: Version 1 (Core Feature - MUST COMPLETE DURING LAB)
**Goal:** Single, working recipe generator  
**Components:**
- FastAPI backend with `/api/generate` endpoint
- Basic HTML form + vanilla JS (no frameworks)
- PostgreSQL integration (Docker)
- LLM integration (test with mock first, then real API)

**Key Files:**
- `backend/main.py`: FastAPI app with `@app.post("/api/generate")`
- `backend/models.py`: Pydantic models for Recipe input/output
- `frontend/index.html`: Simple form with ingredient input + appliance dropdown
- `docker-compose.yml`: Services for postgres + backend (frontend served via backend)

**Testing Requirement:** TA must successfully generate 1+ recipes during lab

### Phase 2: Version 2 (Full Deployment - COMPLETE BY DEADLINE)
**Goal:** Production-ready with history feature and full Dockerization  
**Additions:**
- Recipe Vault: `/api/recipes` endpoint with GET for history
- Frontend recipe list view (display previous recipes)
- Proper error handling & validation
- Full docker-compose with all services
- Production-ready documentation

---

## Project Structure
```
se-toolkit-hackathon/
├── .github/
│   └── copilot-instructions.md       (this file)
├── backend/
│   ├── main.py                        (FastAPI app, endpoints)
│   ├── models.py                      (Pydantic models)
│   ├── llm_service.py                 (LLM integration logic)
│   ├── database.py                    (PostgreSQL connection)
│   └── requirements.txt                (Python dependencies)
├── frontend/
│   ├── index.html                     (Single HTML file)
│   ├── style.css                      (Tailwind-based styling)
│   └── script.js                      (Vanilla JS logic)
├── docker-compose.yml                 (All services)
├── Dockerfile                         (Backend image)
├── README.md                          (Lab 9 mandatory format)
├── LICENSE                            (MIT)
└── .gitignore
```

---

## Critical Developer Workflows

### Local Development
```bash
# Backend only (no Docker)
cd backend
pip install -r requirements.txt
export OPENAI_API_KEY="sk-..."
python -m uvicorn main:app --reload

# Full stack with Docker
docker-compose up

# Test endpoints
curl -X POST http://localhost:8000/api/generate \
  -H "Content-Type: application/json" \
  -d '{"ingredients": ["eggs", "bread"], "appliance": "toaster"}'
```

### Database Migrations
- Use SQLAlchemy or raw SQL scripts in `/backend/migrations/`
- Seed initial data on first run (appliance list)
- Version schema changes explicitly

### Testing & Verification
- Unit tests for LLM prompt formatting: `backend/test_llm_service.py`
- Integration tests for endpoints: `backend/test_api.py`
- Manual TA walkthrough: Generate recipe → Check DB → Display in history

---

## Code Patterns & Conventions

### Backend (FastAPI)
**Endpoint Structure:**
```python
@app.post("/api/generate")
async def generate_recipe(request: RecipeRequest):
    """System prompt must be specific to dorm cooking + single appliance."""
    recipe = await llm_service.generate(request.ingredients, request.appliance)
    db.save_recipe(recipe)
    return {"recipe": recipe, "id": recipe.id}
```

**System Prompt Pattern** (CRITICAL - affects recipe quality):
```python
SYSTEM_PROMPT = """You are a dorm cooking expert. Generate a detailed, step-by-step recipe 
using ONLY the provided ingredients and ONE specific appliance. 
Format as JSON: {"title": "...", "steps": [...], "time_minutes": int, "difficulty": "easy|medium|hard"}"""
```

**LLM Service** (Abstraction layer for easy switching):
```python
# Support both OpenAI and local models
class LLMService:
    def __init__(self, provider: str = "openai"):  # or "local"
    async def generate(self, ingredients: list, appliance: str) -> Recipe:
```

### Frontend (Vanilla JS)
- Single `index.html` with embedded `<style>` and `<script>`
- Fetch API (not axios): `fetch('/api/generate', {method: 'POST', body: JSON.stringify(...)})`
- Show loading state during LLM call (2-10 seconds typical)
- Display recipes with Tailwind classes directly on elements

### Database (PostgreSQL)
**Recipes Table:**
```sql
CREATE TABLE recipes (
    id SERIAL PRIMARY KEY,
    ingredients TEXT[] NOT NULL,
    appliance VARCHAR(100) NOT NULL,
    content JSONB NOT NULL,  -- Full recipe from LLM
    created_at TIMESTAMP DEFAULT NOW()
);
```

---

## Environment Variables & Secrets

**Backend (.env):**
```
OPENAI_API_KEY=sk-...
DATABASE_URL=postgresql://user:pass@localhost:5432/dormchef
LLM_PROVIDER=openai  # or "local"
LLM_MODEL=gpt-4o-mini
```

**Docker Compose (.env):**
```
POSTGRES_PASSWORD=secure_password
POSTGRES_DB=dormchef
```

**Never commit secrets.** Use `.gitignore` + environment variables.

---

## Integration Points & External Dependencies

### LLM Integration
- **Primary:** OpenAI API (gpt-4o-mini recommended for cost/performance)
- **Fallback:** Local model via Ollama (for testing without API key)
- **Timeout:** Set 30s limit on LLM calls to avoid frontend hang
- **Rate Limiting:** Implement with backend counter to avoid API overuse

### PostgreSQL
- Connection pooling via `asyncpg` (FastAPI best practice)
- Migrations: Track schema versions in DB
- Backups: Ensure docker volume persists `/var/lib/postgresql/data`

### Frontend ↔ Backend
- Single origin (backend serves frontend static files)
- CORS only needed if frontend deployed separately
- Error responses: Always include `{"error": "message"}` structure

---

## Git Workflow & Commit Strategy

**Branch Structure:**
- `main`: Production-ready code
- `version/1`: Phase 1 completion (TA demo)
- `version/2`: Phase 2 completion (deployment)
- Feature branches: `feat/recipe-history`, `fix/llm-timeout`

**Commit Messages:**
```
feat: add recipe generation endpoint
fix: handle empty ingredient list in validator
docs: update README with deployment steps
chore: lock dependencies in requirements.txt
```

**Key Milestones:**
- After Phase 1 TA approval: Tag `v1.0` on `version/1`
- Final submission: Tag `v2.0` on `main`

---

## TA Feedback Integration Points

**Phase 1 Feedback** (address in Phase 2):
- Recipe quality/relevance issues → Refine system prompt
- UX improvements → Add recipe preview or favorites
- Database schema changes → Plan migrations

**Phase 2 Deployment Checklist:**
- [ ] All endpoints tested with TA
- [ ] Recipe history displays correctly
- [ ] Docker deployment works on fresh Ubuntu 24.04
- [ ] README follows required structure
- [ ] MIT license present
- [ ] Git history clean (no secrets, logical commits)

---

## Quick Reference: Common Tasks

| Task | Command | Notes |
|------|---------|-------|
| Start dev server | `docker-compose up` | Mounts `/backend` for hot reload |
| Run backend tests | `cd backend && pytest` | Requires pytest in requirements.txt |
| Generate sample recipe | `curl -X POST http://localhost:8000/api/generate -H "Content-Type: application/json" -d '{"ingredients": ["eggs"], "appliance": "air fryer"}'` | Manually test LLM integration |
| Check database | `docker exec dormchef-db psql -U dormchef -d dormchef -c "SELECT * FROM recipes LIMIT 5;"` | Verify persistence |
| Rebuild image | `docker-compose build --no-cache` | After requirements.txt changes |

---

## Anti-Patterns to Avoid

❌ **Blocking LLM calls** → Use `async/await`  
❌ **Hardcoded appliance list** → Store in database  
❌ **No input validation** → Use Pydantic models for all API inputs  
❌ **Raw SQL queries** → Use ORM or parameterized queries to prevent injection  
❌ **LLM directly returning free text** → Always parse JSON to ensure consistency  
❌ **Forgetting docker volumes** → Postgres data disappears on container restart  

---

## Success Metrics

✅ **Phase 1:** TA generates ≥1 working recipe during lab  
✅ **Phase 2:** Application deployed, accessible, with working history feature  
✅ **Deployment:** Works on fresh Ubuntu 24.04 VM per deployment instructions  
✅ **Code Quality:** Clean git history, no secrets, documented endpoints  
✅ **Documentation:** README complete, endpoints documented
