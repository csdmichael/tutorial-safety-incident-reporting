# Architecture Proposal — Tutorial Safety Incident Reporting

**Status:** Proposed for review  
**Lifecycle stage:** Design  
**Project:** Tutorial Safety Incident Reporting  
**Target environment:** Dev

## 1. Executive Summary

This proposal defines a reviewable architecture for a mobile-first tutorial application that supports the end-to-end safety incident workflow:

1. rapid incident reporting on site,
2. triage and notification by a safety lead,
3. corrective-action tracking through verified completion,
4. closure into a retained record suitable to support downstream statutory reporting.

The architecture aligns with the selected stack:

- **UI:** Angular + Ionic
- **API:** Python + FastAPI
- **Database:** PostgreSQL

It is designed for:

- responsive mobile and desktop use,
- secure handling of sensitive incident information,
- clear workflow state transitions,
- auditability,
- automated testing of the main workflow,
- deployment to a Dev environment with configuration externalized under `config/`.

Because no standalone technical requirements or UX mockups were provided, this proposal derives both from the approved requirements artifact and the intake requirements text.

---

## Technical Requirements (Derived)

The following minimum technical requirements are derived from the approved requirements artifact and intake document.

### Functional technical requirements

| ID | Requirement |
|---|---|
| TR-01 | The system shall allow a user on a mobile device to create and submit an incident report with the minimum required fields in a streamlined flow intended to be completed in under one minute under normal conditions. |
| TR-02 | The system shall support role-appropriate access for at least: incident reporter, safety lead, corrective-action owner, and read-only reviewer/auditor. |
| TR-03 | The system shall allow a safety lead to triage an incident, assign severity/classification, record notifications, and move the incident into investigation. |
| TR-04 | The system shall support investigation capture, including narrative findings, contributing factors, attachments or evidence references, and decision history. |
| TR-05 | The system shall support creation, assignment, due dates, status tracking, completion notes, and verification outcomes for corrective actions. |
| TR-06 | The system shall prevent incident closure until required workflow conditions are met, including completion or disposition of corrective actions and recorded verification. |
| TR-07 | The system shall retain a closed incident record containing report, triage, notification, investigation, corrective-action, verification, and closure history. |
| TR-08 | The system shall support export-ready or downstream-consumable closed records without implementing occupational health, insurance claims, or payroll workflows. |
| TR-09 | The system shall provide clear validation, loading, success, failure, and authorization feedback in the UI. |
| TR-10 | The system shall support realistic tutorial sample data clearly separated from runtime configuration and secrets. |
| TR-11 | The system shall expose API endpoints for all primary workflow actions and enforce server-side validation independent of the client. |
| TR-12 | The system shall include automated tests for the main end-to-end workflow and core API/domain behaviors. |

### Non-functional technical requirements

| ID | Requirement |
|---|---|
| NFR-01 | The UI shall be responsive and usable on mobile and desktop screen sizes. |
| NFR-02 | The architecture shall be mobile-first and optimized for low-friction data entry. |
| NFR-03 | Sensitive information shall be protected in transit and at rest. |
| NFR-04 | The system shall maintain an audit trail of significant workflow actions and status changes. |
| NFR-05 | Authentication shall be centralized and authorization shall be role-based. |
| NFR-06 | Configuration values such as endpoints, feature flags, retention settings, and timeouts shall be externalized into JSON files under `config/` and read at runtime. |
| NFR-07 | The solution shall be deployable to the Dev environment using automated CI/CD. |
| NFR-08 | The application shall emit structured logs and basic operational telemetry for troubleshooting in Dev. |
| NFR-09 | The design shall support future integration with downstream systems through explicit integration boundaries rather than direct coupling to tutorial-only logic. |
| NFR-10 | The data model shall support referential integrity, workflow consistency, and traceable history. |

### Assumptions requiring reviewer confirmation

1. **Identity provider** is not specified in the approved artifacts; this proposal assumes an enterprise identity provider compatible with OAuth2/OIDC, with Microsoft Entra ID preferred for Azure-hosted Dev deployment.
2. **Attachment storage** is required logically for evidence references, but the intake does not explicitly require binary file upload in the first release. This proposal supports metadata and an abstraction for attachments; enabling full object storage upload may require explicit approval if desired in scope.
3. **Offline-first behavior** is not explicitly required. This proposal supports mobile-responsive online use, not full offline synchronization.
4. **Statutory reporting output** is interpreted as a complete retained record and export-ready data structure, not generation of jurisdiction-specific regulatory forms.
5. **Notification delivery** is modeled as recorded notification actions and pluggable outbound integration; actual email/SMS provider enablement may require separate approval depending on environment readiness.
6. **PII classification policy** is not provided; this proposal treats incident and person-related data as sensitive by default.

---

## UX Mockups (Derived)

No UX mockups were provided, so the following derived UX structure is proposed from the approved requirements.

### Primary screens

| Screen | Purpose | Primary users |
|---|---|---|
| Sign-in | Authenticate and establish role context | All |
| My Dashboard | Show incidents requiring attention, recent reports, assigned actions | All role-filtered |
| Report Incident | Fast mobile-first incident submission | Reporter |
| Incident Details | View incident summary, status, timeline, and related records | All authorized users |
| Triage & Notifications | Classify incident, assign lead, record notifications | Safety lead |
| Investigation | Capture findings, causes, notes, evidence references | Safety lead / investigator |
| Corrective Actions | Create, assign, update, verify actions | Safety lead / action owner / verifier |
| Closure Review | Validate completion criteria and close incident | Safety lead / approver |
| Closed Record View | Read-only consolidated record for downstream support/export | Reviewer / auditor |
| Administration / Reference Data | Manage tutorial sample reference values if included in scope | Admin |

### Navigation model

- **Mobile:** bottom tab or compact menu for Dashboard, Report, Assigned Actions, Profile; deep-linked workflow pages for incident-specific tasks.
- **Desktop:** left-side navigation with dashboard and work queues; content area for detail views.
- **Contextual navigation:** incident detail page acts as the hub with tabs/segments:
  - Summary
  - Triage
  - Investigation
  - Actions
  - Timeline
  - Closure

### Layout principles

- Mobile-first forms with:
  - large touch targets,
  - progressive disclosure,
  - minimal required fields on initial report,
  - save/submit confirmation,
  - inline validation.
- Timeline-based incident detail view to make workflow history understandable.
- Status badges and due-date indicators for corrective actions.
- Clear empty states, loading states, and error banners.
- Read-only closure record optimized for review and export.

### Derived key form fields

These are proposed domain-derived fields and should be confirmed during review:

- **Incident report:** date/time, location, incident type, brief description, people involved, immediate severity, immediate actions taken, reporter identity/contact, optional evidence reference.
- **Triage:** classification, priority/severity, assigned safety lead, notification required, notification records, investigation required.
- **Investigation:** findings summary, contributing factors, root cause notes, evidence references, recommended actions.
- **Corrective action:** title, description, owner, due date, status, completion note, verification result, verifier, verification date.
- **Closure:** closure summary, lessons learned, closure decision, closed by, closed date.

---

## 2. Architecture Drivers

### Primary drivers

- Mobile-first reporting speed
- Workflow traceability and auditability
- Role-based access to sensitive records
- Clear separation between tutorial app scope and downstream systems
- Fast implementation using selected stack
- Dev-friendly deployment and observability

### Constraints

- Must use Angular + Ionic, FastAPI, PostgreSQL
- Must not embed secrets or environment literals in code
- Must support automated tests
- Must remain business-agnostic in implementation patterns even though this tutorial uses incident terminology from the approved project context

---

## 3. Proposed Architecture Overview

A modular three-tier web architecture is proposed:

1. **Angular + Ionic SPA**
   - responsive mobile/desktop UI
   - role-aware workflow screens
   - communicates with backend via REST APIs
   - uses OIDC/OAuth2 authentication

2. **FastAPI backend**
   - exposes workflow and query endpoints
   - enforces validation, authorization, and workflow rules
   - persists transactional data to PostgreSQL
   - emits audit events and operational telemetry
   - integrates with identity, notification, and downstream export boundaries

3. **PostgreSQL database**
   - stores incidents, actions, workflow states, audit history, and reference data
   - supports relational integrity and reporting-oriented queries

Supporting platform services include identity, observability, CI/CD, and hosting.

---

## 4. Context View

### System context

```text
[Reporter / Worker]
    \
     \ uses
      \
   [Tutorial Safety Incident Reporting UI] ----> [Identity Provider]
                |
                v
      [Tutorial Safety Incident Reporting API]
          |        |         |
          |        |         +----> [Notification Service / Provider]
          |        |
          |        +--------------> [Downstream Statutory/Case Systems boundary]
          |
          +-----------------------> [PostgreSQL Database]

[Safety Lead / Investigator / Action Owner / Reviewer] -> uses UI/API
[Auditor / Admin] -> uses UI/API
```

### External actors and systems

| Actor/System | Interaction |
|---|---|
| Reporter | Creates incident reports and views own relevant records |
| Safety lead | Triages incidents, records notifications, investigates, closes |
| Corrective-action owner | Updates assigned actions |
| Reviewer/Auditor | Reviews closed records and history |
| Identity provider | Authenticates users and provides claims/roles |
| Notification provider | Sends or records outbound notifications |
| Downstream systems | Consume closed-record exports or integration payloads; not managed in this release |

---

## 5. Container View

### Containers

#### 5.1 Web/Mobile UI Container
- **Technology:** Angular + Ionic
- **Responsibilities:**
  - render responsive screens,
  - manage client-side routing,
  - perform client-side validation,
  - acquire tokens from identity provider,
  - call backend APIs,
  - display workflow status and feedback.
- **Notes:**
  - packaged as a web app optimized for mobile browsers;
  - can later be wrapped for native deployment if approved.

#### 5.2 API Container
- **Technology:** Python + FastAPI
- **Responsibilities:**
  - REST endpoints,
  - business workflow orchestration,
  - role-based authorization,
  - server-side validation,
  - audit logging,
  - integration adapters,
  - export/read models.
- **Internal modules proposed:**
  - Identity/Auth
  - Incident Reporting
  - Triage & Notification
  - Investigation
  - Corrective Actions
  - Closure & Records
  - Reference Data
  - Audit & Observability
  - Integration Adapters

#### 5.3 Relational Data Store
- **Technology:** PostgreSQL
- **Responsibilities:**
  - transactional persistence,
  - relational integrity,
  - workflow state storage,
  - query support for dashboards and records.

#### 5.4 Optional Object Storage Boundary
- **Technology:** hosting-platform object storage, if attachment upload is approved
- **Responsibilities:**
  - store evidence files/attachments,
  - retain metadata references in PostgreSQL.
- **Approval note:** full binary attachment handling should be confirmed before implementation.

#### 5.5 Observability Services
- **Responsibilities:**
  - collect logs,
  - collect metrics/traces,
  - support Dev troubleshooting.

---

## 6. Logical Component Design

### API component decomposition

| Component | Responsibilities |
|---|---|
| Auth Adapter | Validate tokens, map claims to application roles |
| User Context Service | Resolve current user permissions and scoped access |
| Incident Service | Create/update incident reports, retrieve summaries/details |
| Triage Service | Classify incidents, assign ownership, record notification decisions |
| Notification Adapter | Abstract outbound notification provider and delivery recording |
| Investigation Service | Manage investigation notes, findings, evidence metadata |
| Corrective Action Service | Create/assign/update/verify actions |
| Closure Service | Enforce closure rules and produce closed record |
| Audit Service | Record immutable workflow events |
| Reference Data Service | Provide incident types, statuses, severity values, etc. from configuration/reference tables |
| Export/Integration Service | Produce downstream-ready record payloads |

### UI component decomposition

| Area | Responsibilities |
|---|---|
| Auth shell | Sign-in, session handling |
| Dashboard/work queues | Role-specific summaries and tasks |
| Incident reporting wizard/form | Fast capture flow |
| Incident detail workspace | Summary + timeline + tabs |
| Triage workspace | Classification and notifications |
| Investigation workspace | Findings and evidence references |
| Corrective action board/list | Assignment and verification |
| Closure review screen | Completion checks and close action |
| Shared feedback components | validation, toasts, banners, loading states |

---

## 7. Data Model

The following relational model is proposed.

### Core entities

| Entity | Purpose |
|---|---|
| User | Application user profile projection from identity provider |
| Role | Application role definition |
| UserRole | Role assignment mapping if not fully externalized to claims |
| Incident | Primary incident record |
| IncidentPerson | People involved or affected by incident |
| IncidentStatusHistory | Workflow status transitions |
| TriageRecord | Triage decision data |
| NotificationRecord | Notifications required/sent/recorded |
| Investigation | Investigation details |
| EvidenceReference | Metadata for evidence/attachments/links |
| CorrectiveAction | Action to remediate/prevent recurrence |
| CorrectiveActionUpdate | Progress updates/history for an action |
| VerificationRecord | Verification of corrective action completion |
| ClosureRecord | Final closure decision and summary |
| AuditEvent | Immutable audit trail |
| ReferenceValue | Configurable reference data where DB-backed values are needed |

### Proposed entity relationships

```text
Incident 1---* IncidentPerson
Incident 1---* IncidentStatusHistory
Incident 1---0..1 TriageRecord
Incident 1---* NotificationRecord
Incident 1---0..1 Investigation
Incident 1---* EvidenceReference
Incident 1---* CorrectiveAction
CorrectiveAction 1---* CorrectiveActionUpdate
CorrectiveAction 1---0..1 VerificationRecord
Incident 1---0..1 ClosureRecord
Incident 1---* AuditEvent
User 1---* CorrectiveAction (owner)
User 1---* VerificationRecord (verifier)
User 1---* AuditEvent
```

### Key fields by entity

#### Incident
- incident_id
- incident_number
- reported_at
- occurred_at
- location
- incident_type_code
- short_description
- detailed_description
- initial_severity_code
- immediate_actions_taken
- reporter_user_id
- current_status_code
- is_sensitive
- created_at
- updated_at

#### TriageRecord
- triage_id
- incident_id
- triaged_by_user_id
- triaged_at
- classification_code
- severity_code
- priority_code
- assigned_safety_lead_user_id
- investigation_required
- triage_notes

#### NotificationRecord
- notification_id
- incident_id
- notification_type_code
- recipient_reference
- delivery_channel_code
- delivery_status_code
- recorded_at
- recorded_by_user_id
- notes

#### Investigation
- investigation_id
- incident_id
- investigator_user_id
- started_at
- findings_summary
- contributing_factors
- root_cause_notes
- recommendations
- completed_at

#### CorrectiveAction
- action_id
- incident_id
- title
- description
- owner_user_id
- due_at
- status_code
- completion_note
- completed_at
- requires_verification
- created_by_user_id
- created_at
- updated_at

#### VerificationRecord
- verification_id
- action_id
- verifier_user_id
- verification_result_code
- verification_notes
- verified_at

#### ClosureRecord
- closure_id
- incident_id
- closure_summary
- lessons_learned
- closure_decision_code
- closed_by_user_id
- closed_at
- export_status_code

#### AuditEvent
- audit_event_id
- aggregate_type
- aggregate_id
- event_type
- event_timestamp
- actor_user_id
- event_payload_json
- correlation_id

### Data model design notes

- Use surrogate UUID primary keys for distributed-safe identifiers.
- Use separate human-readable incident numbers generated by application logic.
- Store enumerations as codes backed by reference data/config.
- Preserve audit history as append-only records.
- Avoid deleting transactional records; use soft-delete only for non-transactional reference data if needed.
- Sensitive free-text fields should be minimized and access-controlled.

---

## 8. Workflow and State Model

### Incident lifecycle

Proposed incident states:

1. Draft
2. Submitted
3. UnderTriage
4. InvestigationInProgress
5. ActionInProgress
6. PendingVerification
7. ReadyForClosure
8. Closed
9. Cancelled

### State transition rules

| From | To | Rule |
|---|---|---|
| Draft | Submitted | Minimum required report fields valid |
| Submitted | UnderTriage | Safety lead opens triage |
| UnderTriage | InvestigationInProgress | Triage completed and investigation required |
| UnderTriage | ActionInProgress | Triage completed and direct actions created without full investigation |
| InvestigationInProgress | ActionInProgress | Investigation completed and actions defined |
| ActionInProgress | PendingVerification | All required actions marked complete and awaiting verification |
| PendingVerification | ReadyForClosure | Required verifications completed successfully |
| ReadyForClosure | Closed | Closure summary completed and authorization satisfied |
| Any non-Closed | Cancelled | Authorized cancellation with audit reason |

### Closure gates

Incident closure requires:
- triage completed,
- investigation completed or explicitly not required,
- all mandatory corrective actions completed,
- required verifications recorded,
- closure summary entered,
- authorized closer role.

---

## 9. API Design Approach

### API style
- RESTful JSON APIs
- OpenAPI generated from FastAPI
- versioning via configurable route prefix in `config/`

### Proposed endpoint groups

| Group | Example operations |
|---|---|
| Auth/User Context | get current user, roles, permissions |
| Incidents | create incident, list incidents, get incident, update incident |
| Triage | submit triage, assign lead, update classification |
| Notifications | record notification, list notifications |
| Investigations | create/update investigation, add evidence metadata |
| Corrective Actions | create action, update action, complete action, verify action |
| Closure | validate closure readiness, close incident, get closed record |
| Reference Data | list incident types, severities, statuses |
| Audit/Timeline | get incident timeline |
| Export | generate downstream-ready record payload |

### API design principles

- Server-side validation is authoritative.
- Role checks enforced per endpoint and per resource.
- Use idempotency where appropriate for create/submit operations if mobile retries are expected.
- Return structured error payloads with user-displayable messages and correlation IDs.
- Avoid exposing internal DB schema directly.

---

## 10. Integration Points

### 10.1 Identity and Authentication
- **Purpose:** user sign-in and token issuance
- **Pattern:** OIDC/OAuth2 authorization code flow with PKCE for SPA
- **Direction:** UI/API consume identity provider
- **Notes:** roles may come from claims, groups, or app-role mapping

### 10.2 Notification Provider
- **Purpose:** send or record notifications triggered during triage/investigation
- **Pattern:** adapter abstraction behind API service
- **Initial scope:** record notification intent and status; actual provider integration configurable
- **Approval note:** enabling real outbound email/SMS may require environment-specific approval

### 10.3 Downstream Record Export Boundary
- **Purpose:** provide closed incident record to downstream statutory/case systems
- **Pattern:** export payload generation and handoff abstraction
- **Initial scope:** export-ready JSON/document representation and status tracking
- **Out of scope:** downstream process execution

### 10.4 Observability Platform
- **Purpose:** logs, traces, metrics
- **Pattern:** application telemetry SDK and platform sink

---

## 11. Security Architecture

### Security objectives

- protect sensitive incident and person-related data,
- ensure only authorized roles can perform workflow actions,
- preserve auditability,
- avoid secret sprawl,
- support secure Dev deployment.

### Authentication
- OIDC/OAuth2 with centralized identity provider
- SPA obtains access token
- API validates JWT bearer tokens
- no local password storage in application

### Authorization
- Role-based access control with optional record-level checks
- Proposed roles:
  - Reporter
  - SafetyLead
  - ActionOwner
  - Reviewer
  - Admin
- Record-level rules:
  - reporters can create and view permitted incidents,
  - safety leads can triage/investigate/close assigned or authorized incidents,
  - action owners can update only assigned corrective actions,
  - reviewers can read closed records,
  - admins manage reference/configuration functions if enabled.

### Data protection
- TLS in transit
- encryption at rest for database and storage
- minimize sensitive fields in logs
- redact or suppress free-text sensitive content from telemetry
- use parameterized queries/ORM protections

### Secrets management
- secrets sourced from environment variables, managed identity, or secret store
- no secrets in code, docs, logs, or JSON config files
- config files contain references, flags, and non-secret tunables only

### Audit and compliance controls
- immutable audit events for:
  - incident submission,
  - triage changes,
  - notification records,
  - investigation updates,
  - action assignment/completion/verification,
  - closure.
- correlation IDs for traceability across UI/API logs
- soft business retention policy configurable

### Application security controls
- input validation on client and server
- output encoding in UI
- CSRF considerations minimized by token-based SPA/API model
- CORS restricted by config
- rate limiting on sensitive endpoints
- dependency and container/image scanning in CI
- SAST/secret scanning in source control pipeline

---

## 12. Deployment Topology

### Dev topology

```text
[User Browser / Mobile Browser]
          |
          v
   [Static Web Hosting / Web App for UI]
          |
      HTTPS + OIDC
          |
          v
      [FastAPI Web App]
          |
     private/app connection
          |
          v
      [PostgreSQL]
          
Supporting:
- Identity Provider
- Observability service
- Secret store / managed identity
- CI/CD pipeline
```

### Azure-oriented deployment assumption for Dev

Because the target environment is Dev and Azure-compatible identity/hosting are natural fits, the following topology is recommended:

- UI hosted as static web app or web app
- FastAPI hosted on managed web app/container-capable service
- PostgreSQL managed service
- managed identity for API to access secret store/telemetry where applicable
- observability via platform-native monitoring

If a different hosting platform is mandated later, the application design remains portable.

### Environment configuration

All tunable non-secret values should be stored in JSON files under `config/`, for example:

- `config/appsettings.dev.json`
- `config/ui.dev.json`
- `config/api.dev.json`
- `config/workflow.dev.json`
- `config/integrations.dev.json`
- `config/security.dev.json`
- `config/observability.dev.json`

Examples of values to externalize:
- API base URLs
- route prefixes and API version labels
- feature flags
- timeout values
- allowed origins
- workflow thresholds and closure rules
- notification provider mode
- telemetry sampling
- retention periods

Secrets remain outside these files.

---

## 13. Operational Considerations

### Observability
- structured JSON logs
- request correlation IDs
- API latency/error metrics
- trace spans for major workflow operations
- dashboard for failed submissions, auth failures, and closure validation failures

### Reliability
- transactional DB operations for workflow changes
- retry-safe client submission patterns
- graceful error handling with user-friendly messages
- health endpoints for API and dependency checks

### Performance
- optimize initial report form for minimal payload and low-latency submission
- paginate dashboard and timeline queries
- index incident status, owner, due date, and created date fields
- use async I/O in FastAPI where appropriate

### Data retention and archival
- closed records retained per configurable policy
- export status tracked separately from closure status
- archival strategy can be added later without changing core workflow model

---

## 14. Testing Strategy Alignment

The architecture supports the required automated tests through the following layers:

| Test layer | Scope |
|---|---|
| Unit tests | domain rules, validators, workflow transitions |
| API integration tests | endpoint behavior, authz, persistence, error handling |
| UI component tests | form validation, state rendering, role-based visibility |
| End-to-end tests | report incident → triage → actions → verification → closure |
| Security tests | auth/authz checks, input validation, dependency scanning |

Key workflow to automate first:
1. reporter submits incident,
2. safety lead triages and records notification,
3. investigation completed,
4. corrective action assigned and completed,
5. verification recorded,
6. incident closed,
7. closed record visible.

---

## 15. Risks and Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Identity/role mapping not yet defined | Delays auth implementation | Confirm IdP and role source early; keep auth adapter abstract |
| Attachment scope ambiguity | Rework in data/storage design | Implement evidence metadata now; add binary storage only if approved |
| Notification provider not selected | Incomplete triage workflow automation | Use adapter with record-only mode in Dev |
| Overly broad free-text capture of sensitive data | Privacy/security concerns | Minimize fields, apply role restrictions, redact logs |
| Workflow rules may evolve during review | Domain logic churn | Centralize state machine and closure validation rules |
| Mobile usability may degrade if forms grow | Reduced reporting speed | Keep initial report minimal and defer non-essential fields |

---

## 16. Approval Items / Decisions Needed

1. Confirm **identity provider** choice; this proposal assumes Microsoft Entra ID for Dev.
2. Confirm whether **binary attachment upload** is in scope for this release or whether evidence references only are sufficient.
3. Confirm whether **real outbound notifications** are required in Dev or whether recorded notification actions are acceptable.
4. Confirm whether **closed-record export format** should be JSON only in this release or also downloadable document output.
5. Confirm final **role model** and whether reviewer/auditor is distinct from safety lead.
6. Confirm whether **reference data** should be DB-managed, config-managed, or hybrid.

---

## Technology Stack

| Layer | Technology | Version or SKU | Rationale |
|---|---|---|---|
| UI framework | Angular + Ionic (TypeScript) | Angular LTS-compatible current project baseline; Ionic current stable compatible with selected Angular version | Matches selectedTechStack, supports responsive mobile-first UX, reusable components, and efficient form workflows for browser-based mobile and desktop use. |
| API runtime and framework | Python + FastAPI | Python 3.12.x, FastAPI current stable | Matches selectedTechStack, provides strong developer productivity, OpenAPI generation, async support, and clean validation patterns for workflow APIs. |
| Data store | PostgreSQL | PostgreSQL 16.x managed service or equivalent Dev SKU | Matches selectedTechStack, supports relational integrity, transactional workflow data, indexing, and audit/history queries. |
| Authentication and identity | OpenID Connect / OAuth2 with enterprise IdP, preferably Microsoft Entra ID | Entra ID tenant-backed app registration or equivalent OIDC provider | Required to satisfy centralized authentication and role-based authorization. Entra ID is a reasonable Azure-aligned assumption, but this should be confirmed if not already approved. **Reviewer confirmation required if another IdP is mandated.** |
| Hosting and compute | Managed web hosting for Angular UI + managed Python app hosting for FastAPI + managed PostgreSQL | Azure App Service / Static Web App class services + Azure Database for PostgreSQL Flexible Server Dev-equivalent SKU | Supports rapid Dev deployment, TLS, identity integration, and operational simplicity. This is an implementation recommendation consistent with targetEnvironment=Dev, not a change to the selectedTechStack. |
| CI/CD and source control | GitHub + GitHub Actions | GitHub hosted repos and Actions runners | Honors systemsOfRecord: sourceCodeOrg=github and buildPipelines=github-actions. Supports branch-based validation, automated tests, security scanning, and deployment workflows. |
| Observability | OpenTelemetry instrumentation + platform-native monitoring sink | OpenTelemetry current stable SDKs + Azure Monitor/Application Insights class service or equivalent | Provides structured logs, traces, and metrics with minimal lock-in. OpenTelemetry is added as an implementation standard to meet observability requirements. |
| Security tooling | GitHub Advanced Security-equivalent capabilities: secret scanning, dependency scanning, code scanning; Python/JS dependency audit tools | Repo/pipeline-integrated scanning services and package-native audit tooling | Needed to meet secure delivery expectations. Uses source-control-native tooling where available and avoids introducing business-specific controls into code. **If paid security features are not already licensed, separate approval may be required.** |

### Stack rationale summary

- The core application stack strictly follows the selected project stack.
- Identity, hosting, observability, and security tooling are necessary supporting technologies to make the selected stack deployable and governable.
- The only items potentially requiring explicit new approval are:
  - a specific identity provider if not already standardized,
  - paid security scanning features if not already licensed,
  - binary attachment storage if added to scope,
  - real notification-provider integration.

---

## 17. Recommended Next Steps

1. Approve or amend the derived technical requirements.
2. Confirm identity provider and role model.
3. Confirm attachment and notification scope.
4. Approve the proposed data model and workflow states.
5. Proceed to implementation planning with:
   - API contract definition,
   - schema migration design,
   - UI route/component breakdown,
   - CI/CD pipeline definition,
   - test plan for the main workflow.

If helpful, I can next turn this into:
- a **C4-style diagram set**,
- a **database schema draft**,
- or an **implementation-ready backlog breakdown**.