# DormChef - AI-Powered Recipe Generator

A full-stack web application that generates personalized recipes based on user-provided ingredients and kitchen appliances using LLM agents.

## Demo

### Screenshots

**Recipe Generator Interface:**
```
┌─────────────────────────────────────────┐
│        🍳 DormChef - Recipe Generator   │
├─────────────────────────────────────────┤
│  Ingredients: eggs, bread, butter       │
│  Appliance: [Toaster ▼]                │
│  [Generate Recipe ✨] Button            │
├─────────────────────────────────────────┤
│  Recipe Title: Buttered Toast Surprise  │
│  ⏱️ 5 min | 😊 Easy | 👥 1 serving     │
│  Instructions: [1-5 steps]              │
│  📋 Recent Recipes: [History]           │
└─────────────────────────────────────────┘
```

## Product Context

### End Users
- University students living in dormitories
- Users with limited cooking equipment
- People looking for quick, ingredient-specific recipes

### Problem Solved
Students often struggle to find recipes that work with:
- Specific kitchen appliances (microwave, air fryer, hot plate, etc.)
- Random ingredients they have on hand
- Time constraints for busy schedules

### Our Solution
DormChef uses LLM agents to intelligently generate customized, actionable recipes that:
- Use ONLY provided ingredients (no substitutions)
- Work with ONE specific appliance
- Include step-by-step instructions with timing
- Are realistic for dorm cooking environments

## Features

### Implemented (Version 1)
✅ Recipe generation via LLM (OpenAI GPT-4o-mini)  
✅ Input validation (ingredients + appliance)  
✅ PostgreSQL persistence for generated recipes  
✅ Recipe history display (paginated)  
✅ Responsive UI with Tailwind CSS  
✅ FastAPI backend with async operations  
✅ Docker containerization (docker-compose)  
✅ Health checks and error handling  

### Planned (Version 2)
📋 User authentication & favorites  
📋 Recipe ratings & community features  
📋 Export recipes (PDF/print)  
📋 Advanced filtering (by difficulty, time, etc.)  
📋 Mobile app version  

## Usage

### Web Application
1. Open browser to `http://localhost:8000`
2. Enter ingredients (comma-separated)
3. Select a kitchen appliance
4. Click "Generate Recipe ✨"
5. View generated recipe with instructions
6. Browse recent recipes in history

### API Endpoints

**Generate Recipe:**
```bash
curl -X POST http://localhost:8000/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "ingredients": ["eggs", "bread", "butter"],
    "appliance": "toaster"
  }'
```

**Get Recipe History:**
```bash
curl http://localhost:8000/api/recipes?skip=0&limit=10
```

**Health Check:**
```bash
curl http://localhost:8000/health
```

## Deployment

### Requirements
- Ubuntu 24.04 LTS
- Docker & Docker Compose installed
- Git
- OpenAI API key (for LLM functionality)

### Step-by-Step Deployment

1. **Clone repository:**
   ```bash
   git clone https://github.com/yourusername/se-toolkit-hackathon.git
   cd se-toolkit-hackathon
   ```

2. **Setup environment:**
   ```bash
   cp .env.example .env
   # Edit .env and add your OPENAI_API_KEY
   nano .env
   ```

3. **Build and start services:**
   ```bash
   docker-compose up --build
   ```

4. **Verify deployment:**
   ```bash
   # Wait for PostgreSQL to be healthy (~5 seconds)
   curl http://localhost:8000/health
   # Should return: {"status": "ok"}
   ```

5. **Access application:**
   ```
   Web: http://localhost:8000
   API: http://localhost:8000/api/recipes
   ```

6. **Optional: Test recipe generation:**
   ```bash
   curl -X POST http://localhost:8000/api/generate \
     -H "Content-Type: application/json" \
     -d '{"ingredients": ["eggs"], "appliance": "microwave"}'
   ```

### Docker Compose Services

| Service | Port | Purpose |
|---------|------|---------|
| `postgres` | 5432 | PostgreSQL database |
| `backend` | 8000 | FastAPI application |

### Database Access

```bash
# Connect to PostgreSQL in container
docker exec -it dormchef-db psql -U dormchef -d dormchef

# View recipes table
SELECT * FROM recipes LIMIT 5;
```

### Logs

```bash
# View backend logs
docker-compose logs -f backend

# View database logs
docker-compose logs -f postgres
```

### Stopping Services

```bash
docker-compose down

# Remove volumes (deletes database data)
docker-compose down -v
```

## Project Structure

```
se-toolkit-hackathon/
├── .github/
│   └── copilot-instructions.md    # AI agent guidelines
├── backend/
│   ├── main.py                    # FastAPI app & routes
│   ├── models.py                  # Pydantic schemas
│   ├── database.py                # PostgreSQL setup
│   ├── llm_service.py             # OpenAI integration
│   └── requirements.txt           # Python dependencies
├── frontend/
│   └── index.html                 # Single-page application
├── docker-compose.yml             # Services definition
├── Dockerfile                     # Backend container image
├── .env.example                   # Environment template
├── .gitignore                     # Git exclusions
├── LICENSE                        # MIT License
├── README.md                      # This file
└── AGENTS.md                      # Agent instructions
```

## Technology Stack

- **Backend:** FastAPI (Python web framework)
- **Database:** PostgreSQL 16
- **Frontend:** Vanilla JavaScript, HTML5, Tailwind CSS
- **LLM:** OpenAI API (GPT-4o-mini)
- **Async:** asyncpg, AsyncSession (SQLAlchemy)
- **Deployment:** Docker & Docker Compose

## Development

### Local Setup (without Docker)

```bash
# Install dependencies
cd backend
pip install -r requirements.txt

# Start PostgreSQL (requires local installation)
# Or use Docker: docker run -d --name postgres -e POSTGRES_PASSWORD=dormchef -p 5432:5432 postgres:16-alpine

# Set environment variables
export OPENAI_API_KEY="sk-your-key"
export DATABASE_URL="postgresql+asyncpg://dormchef:dormchef@localhost:5432/dormchef"

# Run backend
python -m uvicorn main:app --reload

# Open http://localhost:8000
```

### Testing

```bash
cd backend
pytest
```

## Environment Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `OPENAI_API_KEY` | (required) | OpenAI API authentication |
| `DATABASE_URL` | `postgresql+asyncpg://dormchef:dormchef@localhost:5432/dormchef` | PostgreSQL connection |
| `LLM_PROVIDER` | `openai` | LLM service provider |
| `LLM_MODEL` | `gpt-4o-mini` | LLM model identifier |
| `POSTGRES_PASSWORD` | `dormchef` | PostgreSQL password |

## Error Handling

- **Empty ingredients:** Returns 400 with "At least one ingredient required"
- **Missing appliance:** Returns 400 with "Appliance is required"
- **LLM timeout:** Returns 400 with "Recipe generation timed out"
- **Invalid JSON from LLM:** Returns 500 with "Invalid recipe format"
- **Database errors:** Returns 500 with "Internal server error"

## API Response Format

```json
{
  "id": 1,
  "ingredients": ["eggs", "bread", "butter"],
  "appliance": "toaster",
  "content": {
    "title": "Buttered Toast",
    "description": "Simple and quick buttered toast",
    "steps": [
      {
        "step_number": 1,
        "instruction": "Insert bread into toaster",
        "duration_minutes": 3
      }
    ],
    "time_minutes": 5,
    "difficulty": "easy",
    "servings": 1,
    "notes": "Use medium setting"
  },
  "created_at": "2026-04-04T12:00:00"
}
```

## License

MIT License - See LICENSE file for details

## Author

Built for Lab 9 Hackathon - Software Engineering Toolkit  
University: [Your University]  
Email: [Your Email]
