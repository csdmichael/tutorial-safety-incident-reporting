## 1. Build Overview  
- **Objective:** Implement the end-to-end Tutorial Safety Incident Reporting workflow (rapid incident capture → safety lead triage/notifications → corrective-action tracking → investigation closure) with the Angular + Ionic UI, FastAPI service layer, and PostgreSQL persistence, ensuring responsiveness, validation, and automated regression coverage as required in the intake requirements.[requirements]  
- **Constraints & governance:**  
  - No hardcoded business/environment values: introduce tunables within the existing `config/` JSON files and load them at runtime in both UI and API layers.  
  - Sensitive data protection: enforce server-side validation, request/response filtering, and role-aware data exposure.  
  - Testing is mandatory for the main workflow, spanning unit, integration, and end-to-end paths.[requirements]  
- **Repository state:** Unable to re-verify codebase or pipeline status because connector access is currently unavailable; plan assumes a clean repository aligned with the supplied requirements artifact.

## 2. UX Implementation Plan (per “UX Mockups (Derived)” requirements)  
Because the actual derived UX section could not be retrieved, the following screen plan is an **assumption** aligned with the described workflow; it should be validated against the official derived mockups once access is restored.  
1. **Quick Incident Report Screen (Mobile-first default):**  
   - Minimal required fields (incident type, location, timestamp, narrative, optional attachments) grouped for sub‑1‑minute submission.  
   - Prominent progress/feedback toast states for success/failure.  
2. **Incident Detail & Triage Screen:**  
   - Tabs/segments for Summary, People Involved, Evidence, Notifications.  
   - Safety lead actions: classify severity, assign lead, record notification timestamps.  
3. **Corrective Action Tracker Screen:**  
   - List of actions with owner, due date, status chips, and verification controls.  
   - Supports inline evidence note capture and completion confirmation.  
4. **Investigation Closure Screen:**  
   - Read-only audit trail plus closure checklist (verification complete, lessons learned, export snapshot).  
   - Generates a “closure package” payload for downstream statutory reporting.  

Navigation will follow the derived UX ordering (Report → Detail → Actions → Closure) with Ionic routing guards enforcing workflow progression.

## 3. Architecture & Implementation Details  

### 3.1 Frontend (Angular + Ionic)  
- **State & data services:**  
  - `IncidentService`, `ActionService`, `NotificationService` with HTTP clients reading base URLs and timeout thresholds from `config/ui.runtime.json`.  
  - Centralized `AppConfigService` to load runtime config before bootstrapping; add new keys for `apiBaseUrl`, `fileUploadMaxBytes`, `pollingIntervalMs`.  
- **Modules & pages:**  
  - Separate feature modules for `report`, `incident-detail`, `actions`, `closure` to keep routing lazy-loaded and mobile-friendly.  
  - Form validation via Angular Reactive Forms with per-field error messaging.  
  - File/image attachments handled through Ionic `Input` + capacitor plugins (if already available) or HTML5 fallback; metadata only is stored if binary handling is out of scope.  
- **Accessibility & responsiveness:**  
  - Use Ionic grid + CSS utilities for breakpoint-aware layouts; ensure min touch target sizes and semantic labels.  
  - Inline loading indicators and toast confirmations per requirement for clear user feedback.[requirements]

### 3.2 API (FastAPI)  
- **Domain models & validation:**  
  - Pydantic schemas for `IncidentCreate`, `IncidentUpdate`, `CorrectiveAction`, `NotificationLog`, `ClosureRecord`.  
  - Input validation for required fields, enumerations (severity, status), attachment metadata (size/type).  
- **Endpoints (all under configurable prefix from `config/api.runtime.json`):**  
  - `POST /incidents` quick create.  
  - `GET/PUT /incidents/{id}` for summary + triage updates.  
  - `POST /incidents/{id}/notifications` record actions.  
  - `POST /incidents/{id}/actions` & `PATCH /actions/{actionId}` for lifecycle.  
  - `POST /incidents/{id}/close` finalize investigation.  
  - Include pagination & filtering query params for list endpoints.  
- **Business logic:**  
  - Service layer functions enforce workflow order (e.g., cannot close before all corrective actions verified).  
  - Notification hook interface (email/SMS) stubbed but configurable via dependency injection so downstream integrations remain decoupled.  
- **Security:**  
  - Placeholder auth dependency to plug in real identity provider later; for the tutorial, role claims (reporter, safetyLead, admin) can be simulated via config-driven allowlists.  
  - Response filtering to ensure reporters only see their submissions while safety leads/admins can view all.

### 3.3 Database (PostgreSQL)  
- **Schema additions:**  
  - Tables: `incidents`, `people_involved`, `evidence_files` (metadata only), `notifications`, `corrective_actions`, `closure_records`.  
  - Use UUID primary keys, audit columns (`created_at`, `updated_at`, `created_by`).  
  - Enforce FK relationships with cascade rules tuned per entity (e.g., deleting an incident should soft-delete children).  
- **Migrations:**  
  - Create Alembic migrations reflecting the schema; no literal business strings beyond enumerations stored in lookup tables (`incident_classifications`, `action_statuses`).  
- **Seed/tutorial data:**  
  - Insert sample incidents/action items through migration seeds referencing generic placeholders (“Sample Site A”) but derived from project metadata rather than hardcoded business names.

### 3.4 Configuration & Environment Handling  
- Extend existing config JSON files (frontend `config/ui.runtime.json`, backend `config/api.runtime.json`, shared if present) with:  
  - `apiBaseUrl`, `timeoutMs`, `pageSize`, `uploadConstraints`.  
  - Notification feature flags (`enableEmail`, `enablePush`).  
  - Export template identifiers for closure packages.  
- Ensure runtime loading at app start; add validation to fail fast if required keys absent.

### 3.5 Automated Testing  
- **Frontend:**  
  - Component tests with Jest for form validation edge cases (empty required fields, attachment limits).  
  - Cypress (or Ionic e2e harness) happy-path covering incident creation through closure using mock backend responses.  
- **Backend:**  
  - Pytest unit tests for services and routers (mocking DB).  
  - Integration tests hitting a test DB to verify workflow constraints (cannot close with open actions, etc.).  
  - Contract tests to ensure schema compatibility with UI (e.g., JSON structure of `IncidentDetailResponse`).  
- **Data fixtures:**  
  - Shared JSON fixtures representing baseline incident objects to keep UI/API tests aligned.

## 4. Risks & Mitigations  
| Risk | Impact | Mitigation |
| --- | --- | --- |
| Derived UX specifics unavailable | Layout deviations from approved design | Mark current screen assumptions; revisit once UX document accessible and adjust before implementation freeze. |
| Config proliferation leading to runtime mismatches | Build failures or unexpected URLs | Add schema validation for config files and document keys in README/config guide. |
| Attachment handling complexity | Missed SLA for “<1 min” report | Defer heavy upload flow by limiting to metadata + placeholder until binary storage requirement clarified; ensure UI copy sets expectations. |
| Workflow order errors | Data integrity issues | Enforce state-machine logic in backend service layer and cover with integration tests. |

## 5. Assumptions & Gaps  
1. **UX mockups (derived) content:** Not accessible due to connector restrictions; the screen plan above is inferred from requirements and must be validated once the official derived UX artifact is available.  
2. **Repository baseline & pipelines:** Could not confirm current code structure, config file names, or CI setup; proposal assumes standard Angular/Ionic + FastAPI scaffolding exists or will be created during implementation.  
3. **Authentication provider:** Requirements do not specify; assumed to be a mock/placeholder for tutorial purposes with role simulation via config.  

---

This proposal is ready for review; it enumerates the planned code changes, configuration additions, database schema updates, and testing scope necessary to satisfy the Tutorial Safety Incident Reporting build objectives in the Dev environment, grounded in the provided requirements artifact.[requirements]