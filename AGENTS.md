# Agent Role: Project Architect & Developer (Lab 9 Hackathon)

## 1. Objective
Your goal is to autonomously generate a full-stack web application named "DormChef" that meets all strict criteria of the Software Engineering Toolkit course (Lab 9).

## 2. Project Requirements (Strict)
- **Product Name:** DormChef
- **Stack:** FastAPI (Backend), PostgreSQL (Database), Vanilla JS/HTML/Tailwind (Frontend).
- **Deployment:** Must be Dockerized (docker-compose) and compatible with Ubuntu 24.04.
- **Agent Integration:** The application must utilize an LLM (e.g., OpenAI/Local) to generate content.
- **Git Workflow:** Code must be organized for a clean commit history.
- **Constraints:** NO Telegram bots (blocked on university VMs).

## 3. Implementation Phases (The Roadmap)

### Phase 1: Version 1 (Core)
- **Task:** Build a functioning "Ingredient-to-Recipe" generator.
- **Inputs:** User provides a list of ingredients and a kitchen appliance.
- **Logic:** Call LLM API with a specialized system prompt to return a structured recipe.
- **Persistence:** Save the generated recipe to the database immediately.

### Phase 2: Version 2 (Full Deployment)
- **Database Migration:** Ensure PostgreSQL is used via Docker.
- **History Feature:** Implement a "Recipe Vault" to fetch and display previous generations from the DB.
- **Dockerization:** Create `Dockerfile` and `docker-compose.yml` for the entire stack.
- **Documentation:** Generate a specific `README.md` following the course's mandatory structure.

## 4. Operational Instructions for the Agent
When asked to "Build Phase X", you must:
1. Provide production-ready, clean code with comments.
2. Ensure all environment variables are clearly defined.
3. Adhere to the "se-toolkit-hackathon" repository structure.
4. Include an MIT License file.