# Delivery plan — Tutorial Safety Incident Reporting

Sprints are two weeks. Each sprint closes with a demo and an approval gate.

| Sprint | Focus | Exit criteria |
| --- | --- | --- |
| Sprint 1 | Foundation: repo, pipelines, schema | CI green, API deployed |
| Sprint 2 | Core scope | Approved user stories delivered |
| Sprint 3 | Hardening and release | Tests pass, release gate approved |

## Approved scope

- **Objective:** Implement the end-to-end Tutorial Safety Incident Reporting workflow (rapid incident capture → safety lead triage/notifications → corrective-action tracking → investigation closure) with the Angular + Ionic UI, FastAPI service layer, and PostgreSQL persistence, ensuring responsiveness, validation, and automated regression coverage as required in the intake requirements.[requirements]
- **Constraints & governance:**
- No hardcoded business/environment values: introduce tunables within the existing `config/` JSON files and load them at runtime in both UI and API layers.
- Sensitive data protection: enforce server-side validation, request/response filtering, and role-aware data exposure.
- Testing is mandatory for the main workflow, spanning unit, integration, and end-to-end paths.[requirements]
- **Repository state:** Unable to re-verify codebase or pipeline status because connector access is currently unavailable; plan assumes a clean repository aligned with the supplied requirements artifact.
- **Quick Incident Report Screen (Mobile-first default):**
- Minimal required fields (incident type, location, timestamp, narrative, optional attachments) grouped for sub‑1‑minute submission.
- Prominent progress/feedback toast states for success/failure.
- **Incident Detail & Triage Screen:**
- Tabs/segments for Summary, People Involved, Evidence, Notifications.
- Safety lead actions: classify severity, assign lead, record notification timestamps.
