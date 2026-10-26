# Requirements Proposal — Tutorial Safety Incident Reporting

**Status:** Proposed for review  
**Lifecycle stage:** Plan  
**Project:** Tutorial Safety Incident Reporting  
**Target environment:** Dev  
**Primary source:** `docs/intake/requirements/tutorial-safety-incident-reporting-requirements.md` (“Requirements”)

## 1. Purpose and Scope

Deliver a working tutorial application that enables the end-to-end safety incident workflow for people working on site:

1. Report an incident from a mobile device in under one minute.
2. Enable a safety lead to triage the report and issue notifications.
3. Track corrective actions through verified completion.
4. Close the investigation into a record that supports statutory reporting.

The application must provide clear outcomes for successful and unsuccessful actions, input validation, protection of sensitive information, responsive desktop and mobile support, realistic tutorial sample data, and automated tests for the main workflow.

### In Scope

- Mobile-first incident submission by on-site workers.
- Viewing and updating information appropriate to a user’s role.
- Incident triage, notification tracking, investigation, corrective-action management, verification, and closure.
- A complete tutorial workflow using clearly identified sample data.
- A closed incident record suitable to support a downstream statutory-reporting process.
- Clear validation, error, loading, confirmation, and authorization feedback.
- Responsive application behavior on desktop, tablet, and mobile devices.
- Automated tests covering the primary end-to-end workflow.

### Out of Scope

The following are downstream systems and are not managed within this release:

- Occupational health case management.
- Insurance claims.
- Payroll.

The application may retain a controlled reference or export-ready closed record for downstream handling, but it must not implement those downstream business processes.

## 2. Goals and Measurable Outcomes

| ID | Goal | Proposed measure |
|---|---|---|
| G-01 | Enable rapid incident reporting on site. | A reporter can submit the minimum required incident report in under one minute under normal mobile conditions. |
| G-02 | Ensure safety leads can act on reports promptly. | A safety lead can review, classify, assign, and record notification actions from the incident record. |
| G-03 | Provide accountability for corrective actions. | Each corrective action has an owner, status, evidence or completion note where required, and verification outcome before closure. |
| G-04 | Produce a defensible closure record. | A closed incident retains the required report, triage, notification, investigation, corrective-action, verification, and closure history. |
| G-05 | Provide a safe and usable tutorial experience. | The application protects sensitive data, validates submissions, is responsive, and communicates both successful and unsuccessful outcomes clearly. |
| G-06 | Support reliable delivery. | Automated tests cover the main report-to-closure workflow and key validation and authorization paths. |

## 3. Actors and Responsibilities

| Actor | Description | Primary responsibilities |
|---|---|---|
| Reporter | Any person working on site who reports an incident. | Create and submit an incident report; view the reports they are permitted to view; provide requested clarifications. |
| Safety Lead | Authorized user accountable for safety incident triage and investigation coordination. | Review reports, triage incidents, record notifications, manage investigations, assign and monitor corrective actions, verify completion, and close incidents. |
| Corrective-Action Owner | Authorized person assigned to complete a corrective action. | Review assigned actions, update progress, provide completion information or evidence, and respond to returned actions. |
| Verifier | Authorized person who confirms corrective actions are complete and adequate. This may be the Safety Lead if the organization permits role combination. | Review submitted completion information, verify or return corrective actions, and record verification rationale. |
| System Administrator | Authorized administrator responsible for access configuration and tutorial-data administration. | Manage authorized roles and tutorial-data lifecycle; does not alter audit history. |
| Downstream Consumer | An external downstream process or authorized user using a closed record for statutory reporting. | Receive or access the supported closure record; does not perform occupational health, insurance, or payroll processing in this release. |

> **Assumption A-01:** The tutorial application will use role-based access and may allow one person to hold multiple roles, subject to authorization policy.

## 4. Business Requirements and User Stories

### Epic E-01 — Rapid Incident Reporting

| ID | User story | Acceptance criteria |
|---|---|---|
| US-01 | As a **Reporter**, I want to create an incident report from a mobile device so that I can notify the organization quickly. | 1. The report form is usable on mobile, tablet, and desktop screen sizes. 2. The minimum required fields are clearly identified. 3. The minimum report can be completed and submitted in under one minute in normal conditions. 4. The user receives a clear confirmation after successful submission. 5. The system displays a clear, actionable failure message if submission cannot be completed. |
| US-02 | As a **Reporter**, I want the application to validate my report before submission so that I can correct missing or invalid information. | 1. Required fields are validated before a report is accepted. 2. Validation messages identify the affected field and the corrective action. 3. Invalid input is retained when feasible so the reporter does not need to re-enter unaffected content. 4. Validation is accessible to screen-reader and keyboard users. |
| US-03 | As a **Reporter**, I want to review a submitted report that I am authorized to access so that I can confirm what was reported and respond to follow-up. | 1. The reporter can view an authorized report and its current lifecycle status. 2. The reporter cannot view restricted internal information unless granted permission. 3. If clarification is requested, the reporter can provide a response where authorized. 4. The application confirms successful updates and explains rejected updates. |

### Epic E-02 — Triage and Notifications

| ID | User story | Acceptance criteria |
|---|---|---|
| US-04 | As a **Safety Lead**, I want to review newly submitted incidents so that I can prioritize the appropriate response. | 1. New and active incidents are available through a role-appropriate work queue. 2. Each listed item shows sufficient non-sensitive summary information to identify the work item and its status. 3. The Safety Lead can open an incident and view the submitted report, prior activity, and permitted attachments or evidence. 4. Access to incident records is denied and logged for unauthorized users. |
| US-05 | As a **Safety Lead**, I want to record triage decisions so that the incident has a documented initial assessment. | 1. The Safety Lead can record triage classification, priority, assigned investigation responsibility, and triage notes. 2. The application validates required triage information before allowing completion. 3. The triage action updates the incident status and records an audit event. 4. The interface clearly distinguishes reporter-provided information from internal triage information. |
| US-06 | As a **Safety Lead**, I want to record required notifications so that notification obligations can be tracked. | 1. The Safety Lead can create a notification record associated with an incident. 2. A notification captures its recipient or destination, notification status, date/time, and relevant notes without exposing sensitive details unnecessarily. 3. The application indicates outstanding and completed notification work. 4. Notification failures are visible to the Safety Lead and do not silently mark the notification complete. |

### Epic E-03 — Investigation and Corrective Actions

| ID | User story | Acceptance criteria |
|---|---|---|
| US-07 | As a **Safety Lead**, I want to document the investigation so that findings and decisions are traceable. | 1. The Safety Lead can record investigation findings, relevant dates, and supporting references or evidence. 2. Investigation information is versioned through audit events. 3. The system prevents closure while required investigation information is incomplete. 4. The application provides a clear explanation of incomplete prerequisites. |
| US-08 | As a **Safety Lead**, I want to assign corrective actions so that identified issues are addressed. | 1. The Safety Lead can create one or more corrective actions linked to an incident. 2. Every corrective action includes a description, assignee, target date when applicable, and status. 3. The assignee can access the action only when authorized. 4. Assignment and reassignment are auditable. |
| US-09 | As a **Corrective-Action Owner**, I want to update my assigned work so that the Safety Lead can monitor progress. | 1. The action owner can view authorized assigned actions and their required completion information. 2. The owner can update progress and submit completion information. 3. The application prevents unauthorized users from changing an action. 4. A successful update is confirmed and a failed update explains why it did not succeed. |
| US-10 | As a **Verifier**, I want to verify or return a completed corrective action so that only adequate work is counted as complete. | 1. The Verifier can review an action submitted for verification. 2. The Verifier can mark it verified or return it with a rationale. 3. A returned action becomes visible to its owner with the required follow-up information. 4. Verification outcome, verifier identity, date/time, and rationale are included in the audit history. |

### Epic E-04 — Closure and Downstream Reporting Support

| ID | User story | Acceptance criteria |
|---|---|---|
| US-11 | As a **Safety Lead**, I want to close an incident only when required work is complete so that the resulting record supports statutory reporting. | 1. Closure is blocked until configured required triage, notification, investigation, corrective-action, and verification conditions are met. 2. The Safety Lead can record a closure decision and closure rationale. 3. The closed record presents the information needed to support downstream statutory reporting. 4. Closing an incident records an immutable audit event. |
| US-12 | As an **authorized downstream consumer**, I want to access a controlled closed-incident record so that I can perform statutory reporting outside this application. | 1. The system exposes only the permitted closed-record information through an approved access or export mechanism. 2. The application does not implement occupational health, insurance, or payroll workflows. 3. Access or export events are audited. 4. The mechanism minimizes unnecessary sensitive-data disclosure. |

### Epic E-05 — Tutorial Quality, Feedback, and Assurance

| ID | User story | Acceptance criteria |
|---|---|---|
| US-13 | As a **tutorial user**, I want realistic sample records clearly identified as tutorial data so that I can practice the workflow safely. | 1. Sample data is clearly labelled as tutorial data. 2. Sample data contains no real personal or incident information. 3. Sample records allow the main workflow to be demonstrated from reporting through closure. 4. Tutorial data can be reset or re-provisioned by an authorized administrator under a controlled process. |
| US-14 | As a **user**, I want consistent feedback for loading, success, validation, authorization, and unexpected failures so that I understand what happened and what to do next. | 1. Loading states prevent duplicate submissions. 2. Successful actions receive visible confirmation. 3. Errors are expressed in understandable, actionable language. 4. Error feedback does not disclose sensitive information or internal implementation details. |
| US-15 | As a **delivery team**, I want automated tests for the main workflow so that the tutorial remains reliable as it changes. | 1. Automated tests cover the report, triage, notification, corrective-action, verification, and closure flow. 2. Tests cover required-field validation and unauthorized access. 3. Tests use non-production tutorial data. 4. Test results are available to the delivery pipeline. |

## 5. Workflow and Lifecycle

```text
Draft Report
   ↓ submit
Submitted
   ↓ triage
Triaged / Under Investigation
   ↓ create and assign actions
Corrective Actions In Progress
   ↓ all required actions completed and verified
Ready for Closure
   ↓ closure approval
Closed
   ↓ controlled access/export
Available for Downstream Statutory Reporting
```

A report may require clarification or a corrective action may be returned for further work. Such events return the relevant work item to an active state while preserving its prior history.

> **Assumption A-02:** Incident lifecycle labels, severity categories, notification rules, required closure criteria, and statutory-report fields will be configurable rather than embedded in application code.

## 6. Traceability Matrix

| Requirement / proposal item | Source | Traceability note |
|---|---|---|
| Mobile experience for anyone working on site | Intake Requirements, paragraph 1 | Drives mobile-first reporter flow and responsive requirements. |
| Incident reporting in under one minute | Intake Requirements, paragraph 1 | Drives G-01 and US-01. |
| Triage and notification by safety lead | Intake Requirements, paragraph 1 | Drives Safety Lead role, US-04 through US-06. |
| Corrective actions through verified completion | Intake Requirements, paragraph 1 | Drives Corrective-Action Owner and Verifier roles, US-08 through US-10. |
| Close investigation into statutory-reporting-supporting record | Intake Requirements, paragraph 1 | Drives US-11, US-12, closed-record design. |
| Occupational health, insurance, and payroll outside release | Intake Requirements, paragraph 1 | Drives explicit out-of-scope boundary and downstream-only treatment. |
| End-to-end working tutorial application | Intake Requirements, paragraph 2 | Drives tutorial-data requirements and complete workflow. |
| Review and update needed information | Intake Requirements, paragraph 2 | Drives role-based queues, incident detail, action updates, and clarification functionality. |
| Clear success and failure feedback | Intake Requirements, paragraph 2 | Drives US-14 and UX states. |
| Realistic sample data | Intake Requirements, paragraph 2 | Drives US-13. |
| Validate input | Intake Requirements, paragraph 2 | Drives US-02 and validation requirements. |
| Protect sensitive information | Intake Requirements, paragraph 2 | Drives security, privacy, access, and audit requirements. |
| Desktop and mobile support | Intake Requirements, paragraph 2 | Drives responsive and accessibility requirements. |
| Automated tests for main workflow | Intake Requirements, paragraph 2 | Drives US-15. |
| Angular + Ionic, FastAPI, PostgreSQL | Project context, `selectedTechStack` | Implementation constraint informing derived technical requirements. |

## Technical Requirements (Derived)

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

## UX Mockups (Derived)

> **Derived section:** No UX mockups were provided. The following textual wireframes define a mobile-first, responsive, and WCAG 2.2 AA-compliant baseline for review. Labels and fields remain subject to approved taxonomy and statutory requirements.

### A. Screen Inventory

| Screen | Purpose | Primary actor | Entry point |
|---|---|---|---|
| Sign In / Access Gateway | Authenticate the user and establish authorized access. | All users | Application launch or protected-route redirect |
| My Work | Present role-appropriate actions, submitted reports, assigned actions, and relevant status. | All authenticated users | Successful sign-in; primary navigation |
| Report Incident | Capture the minimum information required to submit a rapid incident report. | Reporter | “Report incident” action from My Work |
| Report Confirmation and Detail | Confirm submission and show the authorized report record and status. | Reporter | Successful report submission; selected report from My Work |
| Incident Work Queue | Prioritize and open incidents requiring triage or other safety-lead action. | Safety Lead | Primary navigation from My Work |
| Incident Detail and Triage | Review the incident and manage triage, notifications, investigation, actions, and closure readiness. | Safety Lead | Selected incident from Incident Work Queue |
| Corrective Action Detail | View, update, submit, verify, or return corrective action work according to role. | Corrective-Action Owner, Verifier, Safety Lead | Selected action from My Work or Incident Detail |
| Closure Review | Confirm all configured requirements are satisfied and record closure. | Safety Lead | “Review closure” action from Incident Detail |
| Closed Record | View the completed, access-controlled record that supports downstream statutory reporting. | Safety Lead, authorized Downstream Consumer | Selected closed incident or approved controlled access path |
| Tutorial Data Administration | Reset or re-provision clearly marked tutorial records. | System Administrator | Administrative navigation |

### B. Navigation Flow

```text
Sign In / Access Gateway
  └── My Work
       ├── Report Incident
       │    └── Report Confirmation and Detail
       │         └── My Work
       ├── Incident Work Queue [Safety Lead]
       │    └── Incident Detail and Triage
       │         ├── Corrective Action Detail
       │         │    └── Incident Detail and Triage
       │         └── Closure Review
       │              └── Closed Record
       ├── Corrective Action Detail [Owner / Verifier]
       │    └── My Work or Incident Detail and Triage
       ├── Closed Record [authorized users]
       └── Tutorial Data Administration [Administrator]
```

**Responsive behavior**

- **Mobile:** Single-column layouts; primary action remains visually prominent; lower-priority detail is progressively disclosed; navigation uses an accessible menu or tab pattern appropriate to the platform.
- **Tablet:** Primary content remains single-column or split into summary and content where readable; forms retain logical tab order.
- **Desktop:** Queues may use list-and-detail layouts; all capabilities remain available without relying on hover-only controls.
- **All breakpoints:** Touch targets, text reflow, focus order, headings, labels, status messaging, and error summaries conform to WCAG 2.2 AA.

### C. Text Wireframes

#### 1. Sign In / Access Gateway

```text
+-------------------------------------------------------------+
| [Application identity]                                      |
|                                                             |
|                 Safety Incident Reporting                   |
|                                                             |
|  [Brief privacy and authorized-use statement]               |
|                                                             |
|  [ Sign in with approved organization account ]             |
|                                                             |
|  Help / accessibility support                                |
+-------------------------------------------------------------+

Loading state:
- Disabled sign-in control with accessible "Signing in" status.

Error state:
- Error summary: "We could not sign you in."
- Action: "Try again"
- Support link; no technical, credential, or tenant details disclosed.

Accessibility:
- Page title and main heading announced.
- Sign-in control has an accessible name.
- Error status uses an announced live region.
```

#### 2. My Work

```text
+-------------------------------------------------------------+
| [Menu]  Safety Incident Reporting             [User menu]   |
+-------------------------------------------------------------+
| My Work                                                     |
| [ Report an incident ]                                      |
|                                                             |
| Your submitted reports                                      |
| +---------------------------------------------------------+ |
| | [Status]  [Report reference]  [Reported date/time]      | |
| | [Accessible summary]                         [View >]   | |
| +---------------------------------------------------------+ |
|                                                             |
| Assigned corrective actions                                |
| +---------------------------------------------------------+ |
| | [Status] [Action summary] [Target date if applicable]   | |
| | [Incident reference]                        [Open >]    | |
| +---------------------------------------------------------+ |
|                                                             |
| [Safety Lead section, shown only when authorized]          |
| [ View incident work queue ]                               |
+-------------------------------------------------------------+

Empty states:
- Reports: "You have not submitted any reports yet." [Report an incident]
- Actions: "You have no assigned corrective actions."
- Safety queue: "There are no incidents requiring your action."

Loading state:
- Accessible skeleton or progress indicator for each list region.

Error state:
- Inline region-specific error and "Try again" action.
```

#### 3. Report Incident

```text
+-------------------------------------------------------------+
| [Back] Report an incident                                   |
| Progress: Step 1 of [configured steps]                      |
+-------------------------------------------------------------+
| Tell us what happened                                       |
| Required fields are marked.                                 |
|                                                             |
| [Occurrence date and time*              ]                   |
| [Location*                              ]                   |
| [Incident classification*               v]                  |
| [Describe what happened*                ]                   |
| [                                        ]                   |
|                                                             |
| [Add supporting information, if enabled]                    |
| [Save draft, if enabled]       [Review and submit]          |
+-------------------------------------------------------------+

Validation state:
- Error summary at top linking to invalid fields.
- Each invalid field: text explanation directly associated with control.
- Values already entered remain visible.

Loading/submission state:
- "Submitting report…" progress status.
- Submit action disabled to prevent duplicates.

Error state:
- "Your report was not submitted. Review the highlighted fields or try again."
- If a service failure occurs, preserve entered values and provide retry.

Mobile behavior:
- Single-column form; persistent primary action where space permits.
```

#### 4. Report Confirmation and Detail

```text
+-------------------------------------------------------------+
| [Back to My Work]                                           |
| Success: Your incident report was submitted.                |
+-------------------------------------------------------------+
| Incident report [reference]                                 |
| Status: Submitted                                           |
| Reported: [date/time]                                       |
|                                                             |
| What you reported                                           |
| - Occurrence: [authorized value]                            |
| - Location: [authorized value]                              |
| - Classification: [authorized value]                        |
| - Description: [authorized value]                           |
|                                                             |
| Follow-up                                                    |
| [Clarification request, only if applicable]                 |
| [Provide clarification]                                     |
|                                                             |
| [Return to My Work]                                         |
+-------------------------------------------------------------+

Loading state:
- Summary placeholders with an announced loading status.

Error/authorization state:
- "This report is unavailable or you do not have access."
- Provide a safe route back to My Work.
```

#### 5. Incident Work Queue

```text
+-------------------------------------------------------------+
| [Menu] Incident Work Queue                                  |
| [Search authorized incidents]                               |
| [Status filter v] [Priority filter v] [Sort v]              |
+-------------------------------------------------------------+
| Results                                                     |
| +---------------------------------------------------------+ |
| | [Priority/status]  [Incident reference]                 | |
| | [Minimal authorized summary]                             | |
| | Reported [date/time]                         [Open >]   | |
| +---------------------------------------------------------+ |
|                                                             |
| [Load more / pagination control as configured]              |
+-------------------------------------------------------------+

Empty state:
- "No incidents match the current filters."
- Action: "Clear filters."

Loading state:
- Results loading indicator announced to assistive technologies.

Error state:
- "The work queue could not be loaded." [Try again]

Accessibility:
- Filters have labels and keyboard operation.
- Results are exposed as a semantic list/table appropriate to final design.
- Status uses text in addition to color.
```

#### 6. Incident Detail and Triage

```text
+-------------------------------------------------------------+
| [Back to queue] Incident [reference]                        |
| Status: [current status]     Priority: [current priority]   |
| [Actions v]                                                 |
+-------------------------------------------------------------+
| Tabs / sections (keyboard accessible):                      |
| [Report] [Triage] [Notifications] [Investigation]           |
| [Corrective Actions] [History]                              |
+-------------------------------------------------------------+
| Selected section: Triage                                    |
|                                                             |
| Submitted report summary                                    |
| [Authorized reporter-provided content]                      |
|                                                             |
| Triage decision                                              |
| [Classification*                         v]                 |
| [Priority*                               v]                 |
| [Investigation lead*                     v]                 |
| [Triage notes                            ]                  |
|                                                             |
| [Save triage]                                               |
+-------------------------------------------------------------+
| Section: Notifications                                      |
| [Add notification]                                          |
| Notification list with status, date/time, and action links  |
+-------------------------------------------------------------+
| Section: Investigation                                      |
| [Findings / investigation content]                          |
| [Save investigation update]                                 |
+-------------------------------------------------------------+
| Section: Corrective Actions                                 |
| [Create corrective action]                                  |
| Action list: status, owner, target date, verification state |
| [Open action]                                               |
+-------------------------------------------------------------+

States:
- Read-only mode for users without edit authority.
- Field-level validation and an error summary for each editable section.
- Loading indicators per section; do not block review of already loaded content.
- Unauthorized/action failure messages explain the next safe step without exposing data.
```

#### 7. Corrective Action Detail

```text
+-------------------------------------------------------------+
| [Back] Corrective action [reference]                        |
| Status: [current action status]                             |
| Linked incident: [authorized incident reference]            |
+-------------------------------------------------------------+
| Action                                                       |
| Description: [authorized action description]                |
| Owner: [authorized owner identity]                          |
| Target date: [value if applicable]                          |
|                                                             |
| Progress / completion                                        |
| [Progress status*                        v]                 |
| [Completion details*                     ]                  |
| [Supporting evidence, if enabled]                           |
|                                                             |
| [Save update]                 [Submit for verification]     |
+-------------------------------------------------------------+
| Verification (shown to Verifier / Safety Lead as authorized)|
| [Verification outcome*                   v]                 |
| [Verification rationale*                 ]                  |
| [Verify / Return for further work]                          |
+-------------------------------------------------------------+
| History                                                      |
| [Chronological audit-safe activity list]                    |
+-------------------------------------------------------------+

Empty state:
- If no completion has been submitted: "Completion information has not been provided."

Validation/error states:
- Explain missing completion or verification rationale.
- On returned action, prominently show return reason and required next step.

Loading state:
- Announced progress message while action data or updates are loading.
```

#### 8. Closure Review

```text
+-------------------------------------------------------------+
| [Back to incident] Close incident [reference]               |
+-------------------------------------------------------------+
| Closure readiness                                            |
| [✓ / !] Triage: [complete or action required]               |
| [✓ / !] Notifications: [complete or action required]        |
| [✓ / !] Investigation: [complete or action required]        |
| [✓ / !] Corrective actions: [complete or action required]   |
| [✓ / !] Verification: [complete or action required]         |
|                                                             |
| Closure decision                                             |
| [Closure rationale*                     ]                   |
| [Statutory-reporting readiness fields, as configured]       |
|                                                             |
| [Close incident]                                            |
+-------------------------------------------------------------+

Blocked state:
- Closure control disabled when prerequisites fail.
- Each unmet prerequisite links to the relevant incident section.
- Clear text explanation; do not rely on color or icon alone.

Confirmation:
- Modal/dialog with incident reference, irreversible/controlled effect wording,
  and explicit confirmation action.

Error state:
- If closure fails due to a concurrent update, reload status and identify
  what changed without losing entered closure rationale where feasible.
```

#### 9. Closed Record

```text
+-------------------------------------------------------------+
| [Back] Closed incident [reference]                          |
| Status: Closed                                              |
| Closed on: [date/time] by [authorized identity]             |
+-------------------------------------------------------------+
| Record sections                                              |
| [Report] [Triage] [Notifications] [Investigation]           |
| [Corrective actions] [Verification] [Closure] [History]     |
|                                                             |
| Statutory-reporting support                                  |
| [View approved record]                                      |
| [Export / share through approved method, if authorized]     |
+-------------------------------------------------------------+

Authorization state:
- Export/control is visible only to authorized users.
- Denied attempts display a safe message and create an audit event.

Loading/error state:
- Per-section progress and retry.
- "The closed record cannot currently be retrieved" with safe return action.
```

#### 10. Tutorial Data Administration

```text
+-------------------------------------------------------------+
| [Admin navigation] Tutorial Data Administration              |
+-------------------------------------------------------------+
| Tutorial data status                                         |
| Records are clearly labelled as tutorial data.              |
| [Current provisioning / reset status]                        |
|                                                             |
| [Re-provision tutorial data]                                 |
| [Reset tutorial data]                                        |
|                                                             |
| Confirmation requirements                                    |
| - Explain affected tutorial records                          |
| - Confirm that non-tutorial records are not affected         |
| - Require explicit authorized confirmation                   |
+-------------------------------------------------------------+

Error state:
- "Tutorial data operation could not be completed."
- Show safe retry/support option; never reveal internal connection details.

Audit:
- Every provisioning/reset request and outcome is recorded.
```

## 7. Acceptance and Approval Criteria

The proposal is ready for approval when reviewers confirm:

1. The defined scope and explicit out-of-scope boundaries are accurate.
2. The actor model and role combinations are acceptable.
3. The user stories and acceptance criteria cover the intended tutorial workflow.
4. Assumptions and open questions have been resolved, accepted, or deferred with an owner.
5. The derived technical requirements meet organizational architecture, security, privacy, accessibility, and compliance expectations.
6. The derived UX flow provides an acceptable mobile-first and responsive baseline.
7. Statutory-reporting support requirements, including jurisdiction and downstream handoff mechanism, are confirmed before implementation design proceeds.