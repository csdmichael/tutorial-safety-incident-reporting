# UX Mockups

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
