# API contracts — Tutorial Safety Incident Reporting

The OpenAPI document is the authoritative contract: Swagger UI at `/docs`, raw document at `/openapi.json`. This table is the summary.

| Method | Path | Purpose | Response |
| --- | --- | --- | --- |
| `GET` | `/health` | Liveness probe used by the deploy pipeline | `{"status": "ok"}` |
| `GET` | `/api/reportings` | List reportings; `?status=` filters | `Reporting[]` |
| `POST` | `/api/reportings` | Create a reporting | `201` + `Reporting` |
| `GET` | `/api/reportings/{id}` | Fetch one reporting | `Reporting` or `404` |
| `PATCH` | `/api/reportings/{id}` | Partial update | `Reporting` or `404` |
| `DELETE` | `/api/reportings/{id}` | Remove a reporting | `204` or `404` |

## `Reporting`

| Field | Type | Notes |
| --- | --- | --- |
| `id` | integer | Server assigned |
| `title` | string | Required, 1–400 characters |
| `reference` | string | Optional, up to 200 characters |
| `status` | enum | `new`, `in-progress`, `complete` |
| `priority` | enum | `low`, `normal`, `high` |
