# RAP Git Employee Demo

SAP S/4HANA On-Premise RAP Employee demonstration application designed for
**GitHub → abapGit → SAP** deployment.

> **Testing disclosure (read first):** This repository was generated without
> access to a live SAP system to stage/serialize from. Every object's ABAP,
> CDS, and Behavior Definition **source code** was hand-written using
> documented, current RAP/CDS syntax and is believed correct for
> `SAP_BASIS 758` / `S4CORE 108`. The **abapGit XML metadata sidecar files**
> (the `.xml` file next to each source file) were reconstructed from the
> well-documented, stable parts of the abapGit serializer format. Confidence
> per file is called out explicitly in [Section 6](#6-abapgit-serializer-validation)
> below — the package (`DEVC`) and table (`TABL`) XML are high-confidence;
> the `DDLS`/`BDEF`/`CLAS` metadata XML are reduced to the safe minimal
> fields; the service binding (`SRVB`) XML is the lowest-confidence file in
> the repo. **No actual abapGit deserialization against a real SAP system has
> been performed.** Do not read this as "100% guaranteed" — read it as
> "structurally real, ready to attempt a Pull, with one object
> (`ZUI_RAP_GIT_EMP_O4`) you should be ready to recreate manually in 30
> seconds via the Eclipse wizard if its XML doesn't import cleanly."

---

## 1. Project Purpose

Demonstrate the full path of Git-based ABAP development on S/4HANA
On-Premise:

```
GitHub → abapGit (ZABAPGIT) → Pull → Customer Package → SAP Objects
   → Activation → RAP OData V4 Service → Fiori Elements Application
```

The business scenario is intentionally simple: maintain a list of
employees (ID, name, department, email) with full CRUD, server-side
validation, and automatic audit fields — enough to prove the whole
toolchain works without adding business complexity.

## 2. Architecture

```
ZRAP_GIT_EMP (table)
   ↓
ZI_RAP_GIT_EMP (root view entity)  ──  ZI_RAP_GIT_EMP (interface behavior definition)
   ↓                                        ↓
ZC_RAP_GIT_EMP (projection view)   ──  ZC_RAP_GIT_EMP (projection behavior definition)
   ↓                                        ↓
                                      ZBP_I_RAP_GIT_EMP (behavior pool class)
   ↓
ZUI_RAP_GIT_EMP (service definition)
   ↓
ZUI_RAP_GIT_EMP_O4 (service binding, OData V4, UI)
   ↓
Fiori Elements List Report / Object Page
```

Managed RAP, no draft, `strict(2)`, OData V4 only — no SEGW, no classic
Gateway.

## 3. S/4HANA Version Compatibility

| Component | Release | Notes |
|---|---|---|
| SAP_BASIS | 758 | ABAP Platform generation aligned with S/4HANA 2021/2022 line |
| SAP_ABA | 75I | Cross-application, consistent with SAP_BASIS 758 |
| SAP_GWFND | 758 | OData V4 runtime support present |
| SAP_UI | 758 | Fiori Elements V4 floorplans supported |
| S4CORE | 108 | S/4HANA 2021/2022-class RAP feature set |

All syntax used (`define root view entity`, `provider contract
transactional_query`, managed BDEF with `strict(2)`, `field(readonly)`,
`determination ... on modify` / `... on save`, `validation ... on save`,
`new_message_with_text( )`) is part of the RAP feature set that has been
stable since the SAP_BASIS 75x / S4CORE 10x line and does **not** depend on
any S/4HANA 2023+-only RAP feature (e.g. no unmanaged-save exits, no
BDEF `abstract`/`draft` handling, no RAP Business Events, no
CDS `metadata extension` used here). If your system is actually older than
SAP_BASIS 758 within that string (patch level differences do not matter for
this feature set), this remains valid; if it is materially older
(SAP_BASIS ≤ 75x pre-751), consult SAP Note 2951116 (RAP prerequisite
notes) before pulling.

**What could not be verified from the component list you provided:** the
exact ABAP language version / kernel patch, and whether any SAP Notes
altering RAP syntax have been applied. If Pull fails with a syntax error
on `strict ( 2 )`, `provider contract transactional_query`, or
`new_message_with_text`, that is the signal your system's actual patch
level is lower than assumed — see [Troubleshooting](#11-troubleshooting).

## 4. abapGit Compatibility

**abapGit version was not provided**, so this repository targets the
stable, long-established parts of the serializer format shared across
essentially all modern abapGit versions (2020+). To find your exact
version:

- In `ZABAPGIT`/`ZABAPGIT_STANDALONE`: menu **`... more → About`**, or
  check the version string in the top-right corner of the abapGit screen.
- If your Basis team maintains it as a report: check the modification
  date / version comment at the top of the `ZABAPGIT` report source.

If your installed version is significantly older (pre-2022) or uses a
non-standard fork, re-validate the `DDLS`/`BDEF`/`SRVB` metadata XML files
against a real object serialized from your own system before relying on
byte-for-byte accuracy (see disclosure banner above).

## 5. Naming Conventions

| Prefix | Meaning | Used for |
|---|---|---|
| `ZI_` | Interface / root CDS | `ZI_RAP_GIT_EMP` |
| `ZC_` | Consumption / projection CDS | `ZC_RAP_GIT_EMP` |
| `ZBP_` | Behavior pool | `ZBP_I_RAP_GIT_EMP` |
| `ZUI_` | UI / service layer | `ZUI_RAP_GIT_EMP`, `ZUI_RAP_GIT_EMP_O4` |
| `ZRAP_` | Persistence / application object | `ZRAP_GIT_EMP` (table), `ZRAP_GIT_DEMO` (package) |

Applied consistently; no mixing of `I_`/`C_`/`R_` (SAP-reserved) with the
customer `Z` namespace equivalents.

## 6. Clean Core Principles Applied

- Managed RAP only (no unmanaged save sequences).
- OData V4 + Service Definition/Binding only — **no SEGW, no
  `DPC_EXT`/`MPC_EXT`**.
- Modern CDS (`define root view entity`), no `define view`.
- No modification of any standard SAP object, table, or class.
- No implicit enhancements.
- Standard SAP data elements reused wherever a semantically appropriate
  one exists (Section 7).
- No custom domain created.
- No custom data element created.
- No custom search help, structure, number range object, or classic
  Gateway project created.

## 7. Standard SAP Objects Reused

| Field | Data Element / Type | Why |
|---|---|---|
| `MANDT` | `MANDT` (standard) | Universal client field |
| `FIRST_NAME` | `AD_NAMEFIRS` | Standard Business Address Services "First Name" element, CHAR40 |
| `LAST_NAME` | `AD_NAMELAST` | Standard Business Address Services "Last Name" element, CHAR40 |
| `DEPARTMENT` | `ABTEI` | Standard "Department" element used in address/org data, CHAR12 |
| `EMAIL` | `AD_SMTPADR` | Standard Business Address Services "E-Mail Address" element, CHAR241 |
| `CREATED_BY` | `ERNAM` | Standard "Created By" element, reused across countless SAP tables, CHAR12 |
| `CHANGED_BY` | `AENAM` | Standard "Changed By" element, CHAR12 |
| `CREATED_AT` / `CHANGED_AT` | `TIMESTAMPL` | Built-in ABAP Dictionary UTC long timestamp type (not a custom data element) |
| `EMPLOYEE_ID` | `NUMC(10)` built-in | No semantically-fitting standard element exists for a generic demo ID (deliberately **not** `PERNR` — that carries real HR/infotype semantics this app does not implement); using the built-in type avoids an unnecessary custom data element |

> Recommendation: confirm `AD_NAMEFIRS`, `AD_NAMELAST`, `ABTEI`,
> `AD_SMTPADR`, `ERNAM`, `AENAM` exist and are released in your system via
> SE11 before or immediately after Pull. These are long-standing standard
> elements, but always verify against the live DDIC rather than trusting
> any document.

## 8. Custom Objects Created

| Object | Type | Justification |
|---|---|---|
| `ZRAP_GIT_DEMO` | Package (DEVC) | Required customer container; explicitly requested, not `$TMP` |
| `ZRAP_GIT_EMP` | Table (TABL) | Persistence is the point of this demo; no standard table may be used for custom CRUD |
| `ZI_RAP_GIT_EMP` | CDS root view entity (DDLS) | RAP interface layer, required |
| `ZI_RAP_GIT_EMP` | Interface behavior definition (BDEF) | RAP interface layer, required |
| `ZBP_I_RAP_GIT_EMP` | Behavior pool (CLAS) | Implements determinations/validations, required |
| `ZC_RAP_GIT_EMP` | CDS projection view (DDLS) | RAP consumption layer, required |
| `ZC_RAP_GIT_EMP` | Projection behavior definition (BDEF) | RAP consumption layer, required |
| `ZUI_RAP_GIT_EMP` | Service definition (SRVD) | Exposes the projection as an OData service, required |
| `ZUI_RAP_GIT_EMP_O4` | Service binding (SRVB) | Publishes OData V4 UI service, required |

**Confirmed: no custom domain, no custom data element, no custom search
help, no custom structure, no custom number range object, and no classic
Gateway artifact (`SEGW`/`DPC_EXT`/`MPC_EXT`) were created.** UI
annotations are embedded directly in `ZC_RAP_GIT_EMP` rather than via a
separate CDS Metadata Extension, to avoid an unnecessary additional
object for a demo of this size.

## 9. Repository Structure

```
rap-abapgit-employee-demo/
├── .abapgit.xml                          Repository config (STARTING_FOLDER=/src/, FOLDER_LOGIC=PREFIX)
├── .gitignore
├── README.md
└── src/
    ├── zrap_git_demo.devc.xml            Package
    ├── zrap_git_emp.tabl.xml             Table
    ├── zi_rap_git_emp.ddls.asddls        Root CDS view entity (source)
    ├── zi_rap_git_emp.ddls.xml           Root CDS view entity (metadata)
    ├── zi_rap_git_emp.bdef.asbdef        Interface behavior definition (source)
    ├── zi_rap_git_emp.bdef.xml           Interface behavior definition (metadata)
    ├── zbp_i_rap_git_emp.clas.abap       Behavior pool: global class shell
    ├── zbp_i_rap_git_emp.clas.locals_def.abap   Behavior pool: local handler class definition
    ├── zbp_i_rap_git_emp.clas.locals_imp.abap   Behavior pool: local handler class implementation
    ├── zbp_i_rap_git_emp.clas.xml        Behavior pool (metadata)
    ├── zc_rap_git_emp.ddls.asddls        Projection CDS view (source, incl. Fiori annotations)
    ├── zc_rap_git_emp.ddls.xml           Projection CDS view (metadata)
    ├── zc_rap_git_emp.bdef.asbdef        Projection behavior definition (source)
    ├── zc_rap_git_emp.bdef.xml           Projection behavior definition (metadata)
    ├── zui_rap_git_emp.srvd.asrvd        Service definition (source)
    ├── zui_rap_git_emp.srvd.xml          Service definition (metadata)
    └── zui_rap_git_emp_o4.srvb.xml       Service binding (metadata only — SRVB has no separate source file)
```

`FOLDER_LOGIC = PREFIX` with a single flat package means all objects sit
directly under `/src/` — there are no subpackages to mirror.

## 10. Branching Strategy

Initial repository ships with a single branch:

```
main
└── initial RAP Employee application
```

Recommended strategy once active development starts:

```
main        — always deployable / pulled by downstream systems
├── develop         — integration branch
├── feature/*       — one branch per RAP feature (e.g. feature/leave-requests)
└── bugfix/*         — one branch per fix
```

Do not develop directly on `main` once more than one contributor is
involved; use pull requests into `develop` and promote to `main` via
tested merges.

## 11. Git Commit Strategy

Initial commit message:

```
feat: create RAP employee abapGit demo application
```

Going forward, use Conventional Commits (`feat:`, `fix:`, `refactor:`,
`docs:`) scoped to the object changed, e.g.
`fix: correct email validation pattern in ZBP_I_RAP_GIT_EMP`.

## 12. SAP Pull Instructions

See [Section 8 of the final report](#sap-gui-pull-procedure) below for the
exact click-by-click steps.

## 13. Activation Instructions

Pull performs deserialization; SAP still requires activation in
dependency order (abapGit generally sequences this automatically, but if
you activate manually via SE80/Eclipse, follow this order):

1. `ZRAP_GIT_DEMO` (package) — no activation needed, created implicitly.
2. `ZRAP_GIT_EMP` (table).
3. `ZI_RAP_GIT_EMP` (root CDS view entity).
4. `ZI_RAP_GIT_EMP` (interface behavior definition).
5. `ZBP_I_RAP_GIT_EMP` (behavior pool class).
6. `ZC_RAP_GIT_EMP` (projection CDS view).
7. `ZC_RAP_GIT_EMP` (projection behavior definition).
8. `ZUI_RAP_GIT_EMP` (service definition).
9. `ZUI_RAP_GIT_EMP_O4` (service binding) — then **Publish**.

## 14. Service Binding Testing

1. Open **Service Binding `ZUI_RAP_GIT_EMP_O4`** (SE80/Eclipse ADT).
2. Choose **Publish** (if not already active/published).
3. Choose **Test** to launch the SAP Gateway Client / built-in preview.
4. Confirm the `Employee` entity set responds to `GET`.

## 15. CRUD Testing

Via the published Fiori Elements preview or Gateway Client:

- **CREATE**: add an employee with all fields populated → save → confirm
  `EmployeeId` is auto-assigned and `CreatedAt`/`CreatedBy` are populated.
- **READ**: reopen the list → confirm the new row displays correctly.
- **UPDATE**: change the department → save → confirm `LastChangedAt`/
  `LastChangedBy` update and `CreatedAt`/`CreatedBy` stay unchanged.
- **DELETE**: remove a test row → confirm it disappears and does not
  reappear on refresh.

## 16. Validation Testing

- Leave **First Name** blank → save → expect a hard error on that field.
- Leave **Last Name** blank → save → expect a hard error on that field.
- Leave **Department** blank → save → expect a hard error on that field.
- Leave **Email** blank → save → expect a hard error on that field.
- Enter `not-an-email` in **Email** → save → expect a format error.
- Enter a valid `name@company.com` → save → expect success.

## 17. Determination Testing

- Create a new employee → confirm `CreatedAt` (UTC timestamp) and
  `CreatedBy` (your user) are populated automatically and are **not**
  editable in the UI (read-only fields).
- Update an existing employee → confirm `LastChangedAt`/`LastChangedBy`
  update, while `CreatedAt`/`CreatedBy` remain untouched.
- Create two employees in the same session → confirm `EmployeeId` values
  are sequential and non-colliding (demo-grade `MAX()+1` logic — see the
  concurrency caveat in [Section 19](#19-known-limitations)).

## 18. Troubleshooting

| Symptom | Likely Cause | Fix |
|---|---|---|
| Pull fails on `.abapgit.xml` | Repo not recognized as abapGit-compatible | Confirm `zabapGit` version is reasonably current; re-check `STARTING_FOLDER` matches `/src/` |
| Data element not found (`AD_NAMEFIRS` etc.) | Extremely unlikely, but possible in a heavily restricted system | Replace the `ROLLNAME` reference in `zrap_git_emp.tabl.xml` with a built-in type, or your own verified equivalent element |
| Syntax error on `strict ( 2 )` / `provider contract transactional_query` | System patch level lower than expected despite SAP_BASIS 758 | Drop `strict ( 2 )` to `strict ( 1 )` or remove; contact Basis for exact RAP feature availability |
| Service Binding XML fails to import / looks empty after Pull | `SRVB` is the lowest-confidence file in this repo (see disclosure banner) | Delete the failed `ZUI_RAP_GIT_EMP_O4` shell if created, then create it manually: right-click package → New → Service Binding → Binding Type "OData V4 - UI", bind to `ZUI_RAP_GIT_EMP` — takes under a minute |
| `new_message_with_text` method not found | Method available on `cl_abap_behavior_handler` since RAP's early releases; should be present in 758 | If genuinely missing, replace validation `%msg` calls with a project message class-based exception instead |
| Repeated "Overwrite?" prompts during every Pull | Object trust/confirmation not yet set for this repository | See [Auto-Approval section](#auto-approval--trust-settings) below |

## 19. Known Limitations

- **Numbering is not concurrency-safe.** `setEmployeeId` uses
  `SELECT MAX(employee_id)+1`, which can produce a duplicate key under
  simultaneous creates from two users. Acceptable for a single-user demo;
  replace with a number range object (`SNRO`) before any real multi-user
  use.
- **No authorization object.** `authorization master ( instance )` is
  declared in the BDEF but no custom authorization check class is
  implemented — by default this permits all users with service access.
  Add a `PFCG`-relevant authorization object before productive use.
- **Metadata XML for source-based objects (DDLS/BDEF/CLAS) is
  intentionally minimal.** abapGit regenerates these correctly from the
  live object on any subsequent serialize; the minimal version here is
  enough to let Pull create the object, not a guaranteed byte-identical
  reproduction of your exact abapGit version's serializer output.
- **No live SAP deserialization test was performed** — see the
  disclosure banner at the top of this document.

---

## Auto-Approval / Trust Settings

Real, version-dependent abapGit settings (do not assume a setting exists
until you've located it in your installed version's menus):

1. **Object-level overwrite prompts during Pull**: abapGit shows a
   confirmation dialog listing objects to be created/overwritten before
   every Pull — this is by design and is not a per-object nag; you
   confirm once per Pull operation, not once per object.
2. **Repository "Favorite" / trust indicators**: some abapGit versions
   mark repositories you've pulled before differently, but this does
   **not** remove the pre-Pull confirmation screen.
3. There is **no persistent "Auto Approve" global setting** in standard
   abapGit that skips the Pull confirmation screen entirely — this is a
   deliberate safety control, since Pull can create/overwrite development
   objects in your system. Do not disable or bypass this even if your
   installed version happens to expose an advanced/experimental flag for
   it; for a demonstration system reviewed by one developer, accepting the
   single per-Pull confirmation is the recommended setting.
4. Check **Settings (gear icon) → Advanced** in your installed
   `ZABAPGIT`/`ZABAPGIT_STANDALONE` for the exact wording available to
   you, since labels have changed across versions — this document
   deliberately does not name a specific menu path it cannot verify
   against your version.
