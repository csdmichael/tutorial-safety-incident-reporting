# Tutorial Safety Incident Reporting — API

FastAPI service. Owns validation, authorization, and all database access.

| Path | Purpose |
| --- | --- |
| `/health` | Liveness probe |
| `/docs` | Swagger UI |
| `/openapi.json` | OpenAPI document |
| `/api/reportings` | Reportings collection (GET, POST) |
| `/api/reportings/{id}` | Single reporting (GET, PATCH, DELETE) |
