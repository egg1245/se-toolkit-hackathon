# DormChef - Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2024-04-06

### Added
- **Multi-appliance recipe generation**: Users can select multiple appliances per recipe
- **Appliances CRUD management**: Full API for creating, reading, updating, deleting custom appliances
- **Admin UI**: Settings tab with appliances management interface
- **Dark/Light theme toggle**: Theme switching with localStorage persistence
- **Internationalization**: Full support for English and Russian
- **Enhanced LLM prompts**: Better system prompt for multi-appliance scenarios
- **Comprehensive test suite**: 30+ unit and integration tests
- **Integration test script**: Automated testing via `integration_test.sh`
- **Manual testing guide**: Detailed E2E testing procedures in `TESTING.md`
- `translations.js`: Translation system with 100+ strings
- Default appliance protection: Built-in appliances cannot be modified
- Real-time appliance list validation: Duplicate names rejected
- API documentation: OpenAPI/Swagger docs at /docs

### Changed
- **BREAKING**: API endpoint `/api/generate` now accepts `appliance_ids` array instead of `appliance` string
- **BREAKING**: Recipe response now includes `appliances` array instead of single `appliance` field
- **BREAKING**: Frontend refactored with tab navigation (Generator + Appliances)
- **BREAKING**: Appliance selector changed from dropdown to multi-select checkboxes
- Database schema: Added Appliance table and many-to-many relationship
- Version bumped from 1.0.0 to 2.0.0
- Enhanced system prompt for LLM with better constraints documentation
- Improved error messages with user-friendly formatting

### Fixed
- Recipe validation for empty ingredients/appliances lists
- Appliance validation for duplicate names
- Mock LLM service now supports multi-appliance recipes
- Fallback service handles multi-appliance scenarios correctly

### Deprecated
- Legacy single-appliance recipe format (use appliance_ids array instead)

### Removed
- Single appliance dropdown selector (replaced by checkbox grid)
- String-based appliance parameter (use appliance IDs now)

### Security
- Input validation on all new CRUD endpoints
- Protected default appliances from deletion/modification
- Parameterized database queries for all operations

### Performance
- Async operations for all database queries
- Efficient many-to-many relationship loading
- localStorage for instant theme/language switching
- No blocking LLM calls (30s timeout)

### Documentation
- Updated README with v2.0 features and API examples
- Added TESTING.md with comprehensive manual testing guide
- Added VERSION file with release notes
- Added this CHANGELOG
- Enhanced API docstrings and comments

---

## [1.0.0] - 2024-04-06

### Added
- Initial release of DormChef
- Recipe generation via OpenAI LLM (GPT-4o-mini)
- Single appliance support per recipe
- PostgreSQL persistence
- Recipe history with pagination
- Responsive UI with Tailwind CSS
- FastAPI backend with async operations
- Docker and docker-compose deployment
- Health check endpoint
- Basic input validation

### Features
- Generate personalized recipes based on ingredients and appliance
- View recent recipes in history
- Single page application (SPA)
- Clean, responsive design
- Error handling with user-friendly messages

---

## Roadmap

### Version 2.1 (Planned)
- [ ] User authentication and favorites
- [ ] Recipe ratings system
- [ ] Community recipe sharing
- [ ] Export recipes (PDF, markdown)
- [ ] Advanced filtering by difficulty/time/cuisine

### Version 3.0 (Planned)
- [ ] Mobile application
- [ ] Recipe sharing via URL
- [ ] Dietary restrictions support
- [ ] Ingredient substitutions
- [ ] Video tutorials for recipes
- [ ] Shopping list generation
- [ ] Multi-language expansion (Spanish, French, etc.)

---

## Migration Guide: v1.0 → v2.0

### For API Clients

**Update recipe generation calls:**

```bash
# Old (v1.0)
curl -X POST http://localhost:8000/api/generate \
  -d '{"ingredients": ["eggs"], "appliance": "microwave"}'

# New (v2.0)
curl -X POST http://localhost:8000/api/generate \
  -d '{"ingredients": ["eggs"], "appliance_ids": [1]}'
```

**Update response parsing:**

```javascript
// Old (v1.0)
const appliance = recipe.appliance; // string

// New (v2.0)
const appliances = recipe.appliances; // array of objects
const firstAppliance = appliances[0].name;
```

### For Database

```sql
-- Your existing recipes remain intact
-- New schema includes appliances table
-- Data can be migrated via init script
```

### For Frontend Deployments

- Replace old index.html with new version (tabs + modals)
- No breaking changes for existing recipes display
- Update to support multi-appliance display in history

---

## Contributors

**Lab 9 Hackathon Team**
- Innopolis University
- Software Engineering Toolkit Course

---

[Unreleased]: https://github.com/egg1245/se-toolkit-hackathon/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/egg1245/se-toolkit-hackathon/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/egg1245/se-toolkit-hackathon/releases/tag/v1.0.0
