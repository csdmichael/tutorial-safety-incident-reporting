# Technical Requirements

> **Derived section:** No technical requirements document was provided. The following requirements are derived from the intake requirements, project description, selected technology stack, and governed-delivery constraints. Items marked **Assumption** require reviewer confirmation.

### A. Functional Capabilities by Actor

| Actor | Required capabilities |
|---|---|
| Reporter | Authenticate; create and submit a report; receive confirmation and error feedback; view authorized submitted reports and their status; respond to clarification requests where enabled. |
| Safety Lead | View assigned/new incident work queue; view incident records; triage; record notification activity; capture investigation findings; create and assign corrective actions; assess closure readiness; close eligible incidents; access a statutory-reporting-supporting record. |
| Corrective-Action Owner | View assigned actions; update action progress; submit completion details and permitted evidence; view returned-verification reasons. |
| Verifier | View actions awaiting verification; review completion details; verify completion or return the action with rationale. |
| System Administrator | Manage application role assignments or the integration to the identity/role source; administer tutorial data reset/re-provisioning; view non-sensitive operational health information. |
| Downstream Consumer | Obtain permitted closed-record information through an approved, controlled method. The exact method is subject to confirmation. |

### B. Data Entities, Key Attributes, and Relationships

All entity, field, status, and taxonomy labels must be configurable or derived from approved project artifacts. The names below are logical, review-oriented labels rather than required physical database names.

| Entity | Key attributes | Relationships |
|---|---|---|
| Incident Report | Identifier; lifecycle status; reporter reference; reported date/time; incident occurrence date/time; location reference; narrative; classification; priority; submitted date/time; sensitivity designation | Created by one Reporter; has one or more Triage Decisions, Notification Records, Investigation Records, Corrective Actions, Attachments/Evidence, Audit Events, and one Closure Record when closed. |
| Triage Decision | Identifier; incident reference; classification; priority; assigned investigation lead; notes; decision date/time; decision maker | Belongs to one Incident Report; created by one authorized Safety Lead. |
| Notification Record | Identifier; incident reference; notification type; recipient/destination reference; status; attempted/completed date/time; notes; failure reason where applicable | Belongs to one Incident Report; created or updated by an authorized Safety Lead. |
| Investigation Record | Identifier; incident reference; findings; contributing factors where configured; investigation status; supporting references; recorded date/time; author | Belongs to one Incident Report; may be updated through authorized investigation activity. |
| Corrective Action | Identifier; incident reference; description; owner reference; target date when applicable; status; completion statement; completion date/time | Belongs to one Incident Report; assigned to one Corrective-Action Owner; has zero or more verification events. |
| Corrective-Action Verification | Identifier; corrective-action reference; outcome; verifier reference; rationale; verification date/time | Belongs to one Corrective Action; created by one authorized Verifier. |
| Closure Record | Identifier; incident reference; closure decision; closure rationale; closure date/time; closed-by reference; statutory-reporting readiness indicator | Belongs to one Incident Report; created by an authorized Safety Lead only after configured prerequisites are met. |
| Attachment / Evidence Reference | Identifier; parent entity reference; media metadata; sensitivity designation; upload date/time; uploader reference | May be associated with an Incident Report, Investigation Record, or Corrective Action. Actual storage location must be protected and configurable. |
| User / Role Assignment | Identity-provider subject reference; display attributes as permitted; role assignment; active status | Relates users to authorized application roles and access scopes. |
| Audit Event | Identifier; entity reference; action; actor reference; date/time; before/after summary appropriate to sensitivity; outcome; correlation reference | Relates to all auditable entities and security-relevant events. |
| Tutorial Data Marker | Record classification indicating tutorial/demo status; provisioning or reset reference | Applied to tutorial records to ensure they are distinguishable from any non-tutorial data. |

**Data relationship rules**

- An Incident Report may have multiple corrective actions.
- An Incident Report cannot be closed while configured mandatory records or verified actions remain incomplete.
- A Corrective Action cannot become verified without a Verifier decision.
- Audit history must be append-only to application users.
- Tutorial data must be logically identifiable and segregated from non-tutorial data.

### C. Integrations and External Systems

| Integration / system | Requirement | Status |
|---|---|---|
| Identity provider | The application must authenticate users through an approved identity mechanism and resolve role assignments or authorization claims. | **Assumption A-03:** The specific identity provider and claim model are not yet provided. |
| Notification delivery service | The application must support notification delivery or notification recording for safety-lead-managed notifications. | **Open question OQ-01:** Confirm whether notifications are in-app only, delivered through an enterprise service, or both. |
| Downstream statutory-reporting process | The closed record must be made available through a controlled approved mechanism. | **Open question OQ-02:** Confirm whether this release requires an export, a read-only integration API, or manual retrieval. |
| Attachment/evidence storage | If files or media are included, storage must enforce authorization, encryption, malware scanning where applicable, size/type controls, and lifecycle rules. | **Assumption A-04:** Attachment support is needed only if approved during detailed design; the intake does not explicitly require it. |
| Source code and CI | Source is governed in the configured source-control system, and automated tests run through the configured build-pipeline system. | Derived from project systems of record. No repository or workflow was supplied for inspection. |

All endpoints, hostnames, integration identifiers, API versions, resource names, feature flags, limits, and timeouts must be held in runtime-read configuration files under the application configuration folder. No environment-specific or secret value may be committed to source control.

### D. Non-Functional Requirements

| Area | Derived requirement |
|---|---|
| Performance | The minimal incident-report workflow must support completion in under one minute under normal mobile network conditions. User-visible interactions should provide a loading indication promptly, and user operations should receive either completion confirmation or actionable error feedback within configurable service-response targets. |
| Availability | The Dev tutorial environment must provide availability appropriate to planned demonstrations and testing. Availability objectives for later environments require approval. The application must fail safely and show recoverable error messaging when dependencies are unavailable. |
| Scalability | The API and database design must support independent scaling of user-facing API workloads and persistent data services. Capacity thresholds, connection limits, retention volumes, and autoscaling rules must be configurable and established through approved operational planning. |
| Reliability and data integrity | State transitions must be validated server-side. Duplicate submission protection and idempotency must be used for write operations where feasible. Partial failures must not falsely indicate a completed report, notification, action update, verification, or closure. |
| Accessibility | The user interface must conform to WCAG 2.2 AA. It must support keyboard-only operation, programmatic labels, visible focus, semantic structure, sufficient contrast, text resizing/reflow, screen-reader announcements for validation and status changes, and non-color-only status indicators. |
| Responsive design | The Angular + Ionic interface must be usable on mobile, tablet, and desktop. Mobile layouts prioritize reporting and assigned-work completion; desktop layouts may present richer queue and detail views without removing functional capability. |
| Localization | **Assumption A-05:** Initial release supports one approved default locale. All user-facing text, date/time formatting, categories, and notification templates must be externalized to support future localization. Confirm required locales, time zone treatment, and language requirements before build. |
| Maintainability | Frontend, API, schema migrations, configuration, and automated tests must be version-controlled. Business rules such as mandatory fields, workflow criteria, categories, and notification conditions should be centrally managed and configurable where feasible. |
| Observability | Capture structured, privacy-safe telemetry for errors, latency, security-relevant events, and workflow outcomes. Logs must not contain credentials or unnecessary sensitive incident narratives. |

### E. Security and Privacy

| Area | Requirement |
|---|---|
| Authentication | Use an approved enterprise authentication mechanism. Sessions/tokens must be validated by the API; unauthenticated access to protected data must be rejected. |
| Authorization | Enforce role-based and record-level authorization server-side for every protected API operation. The UI must not be treated as the authorization boundary. Reporter, Safety Lead, Corrective-Action Owner, Verifier, Administrator, and downstream-consumer permissions must be explicitly defined. |
| Least privilege | Users may access only information and actions needed for their assigned role and authorized scope. Sensitive internal investigation or triage content must not be shown to reporters unless explicitly authorized. |
| Data classification | **Assumption A-06:** Incident records may contain sensitive personal and safety-related information. Treat report narratives, identities, location details, investigation notes, attachments, and audit records as sensitive by default pending the organization’s formal data-classification policy. |
| Data protection | Encrypt data in transit and at rest using approved platform capabilities. Keep secrets exclusively in environment variables, managed identity, or approved secret storage; never commit, display, or log secrets. |
| Audit | Audit authentication-relevant events, authorization denials, report submission, triage, notification changes, assignment/reassignment, action updates, verification, closure, exports, and administrative data-reset activities. Audit records must include actor, action, target, date/time, outcome, and correlation information while minimizing sensitive content. |
| Privacy | Collect only data necessary for incident management and closure support. Provide clear information about required versus optional input. Retention, deletion, and data-subject request handling must follow approved organizational policy. |
| Secure development | Use input validation, output encoding, parameterized database access, secure file handling if enabled, dependency vulnerability management, and security testing appropriate to the selected technology stack. |

### F. Compliance Constraints

- The closed record must support statutory reporting, but the applicable jurisdiction, regulatory regime, required fields, retention periods, and submission format have not been supplied.
- The solution must preserve traceability of material incident-management decisions and controlled changes.
- Accessibility must meet WCAG 2.2 AA.
- Privacy, data retention, residency, and breach-handling requirements must be confirmed against the organization’s governing policies and applicable law.
- Occupational health case management, insurance claims, and payroll processes remain excluded and must not be represented as in-scope system workflows.

### G. Technical Assumptions and Open Questions

| ID | Type | Item |
|---|---|---|
| A-01 | Assumption | Users may hold multiple authorized roles, subject to policy. |
| A-02 | Assumption | Workflow labels, classifications, priority levels, notification rules, closure prerequisites, and statutory-reporting fields are configurable. |
| A-03 | Assumption | An approved identity provider exists but has not yet been identified. |
| A-04 | Assumption | Attachment/evidence upload is optional until explicitly approved; the core workflow works without mandatory attachment submission. |
| A-05 | Assumption | The initial tutorial supports one approved default locale, with localization-ready implementation. |
| A-06 | Assumption | Incident-related information is sensitive by default. |
| OQ-01 | Open question | What notification channels, delivery service, recipient rules, escalation timing, and confirmation requirements are required? |
| OQ-02 | Open question | How must the closed record be supplied for downstream statutory reporting: export, read-only interface, integration API, or another approved method? |
| OQ-03 | Open question | Which jurisdiction(s), statutory-reporting schema(s), retention period(s), and mandatory closure fields apply? |
| OQ-04 | Open question | What exact incident classifications, priority model, location model, and closure criteria should be configured? |
| OQ-05 | Open question | Are anonymous reports, offline report drafting, media capture, or geolocation required? These are not specified in the intake. |
| OQ-06 | Open question | What role combinations are permitted, and must a verifier be independent of the action owner or the Safety Lead? |
| OQ-07 | Open question | What user population, expected concurrency, and service-level objectives should govern production capacity planning? |
| OQ-08 | Open question | What organization-approved identity provider, notification service, evidence storage, and monitoring services must be integrated? |
