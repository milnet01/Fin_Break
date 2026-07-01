<!-- ants-roadmap-format: 1 -->
# finbreak — Roadmap

> **Current version:** 0.0.0 (scaffolded 2026-06-30). See
> [CHANGELOG.md](CHANGELOG.md) for what's shipped; this file
> covers what's **planned**.
>
> **Format:** v1 — see
> [docs/standards/roadmap-format.md](docs/standards/roadmap-format.md).
> Every actionable bullet carries a stable
> `FIBR-NNNN` ID alongside its phase ID
> (`P##`, `FP##`, `DS##`, `DOC##`, `R##`); the phase ID
> categorises blocks while the stable ID identifies individual
> bullets within them. ID is identity, position is priority,
> items are tackled top-to-bottom. `Dependencies:` lines list
> **direct** predecessors only; transitive prerequisites are
> implied by walking the chain.
>
> **Build order rationale:** the layers are built bottom-up so
> each phase rests on a tested one below it. The encrypted
> **security spine** (key derivation → vault → unlock) is the
> *vertical slice* (P02), built first and on purpose — it is the
> load-bearing concern (personal financial data), so it is
> proven end-to-end before any feature sits on top of it. Each
> phase is then a thin, demonstrable increment.

**Legend** (per `docs/standards/roadmap-format.md § 3.3`)

- ✅ Done (shipped)
- 🚧 In progress (being tackled now)
- 📋 Planned (next up for this phase)
- 💭 Considered (research phase; scope or feasibility uncertain)

**Themes** (per `docs/standards/roadmap-format.md § 3.4`)

- 🎨 Features · ⚡ Performance · 🔌 Plugins · 🖥 Platform
- 🔒 Security · 🧰 Dev experience · 📚 Documentation
- 📦 Packaging · 🐛 Bug fixes · 🔍 Findings fold-in
- 🧹 Cleanup / debt

> **Security is a standing concern, not a phase.** Every
> `implement`-Kind item below must satisfy
> [docs/security-model.md](docs/security-model.md); the security
> static-analysis gate wired up in P01 (bandit + pip-audit +
> gitleaks) runs on every phase's audit and every push.

---

## P01 — Bootstrap (target: next)

**Theme:** wire up the build, lint, format, test, **security
scan**, and CI plumbing chosen in Phase A. Zero user-facing
features. Forces the audit + security harness to be
known-working before any business code lands, and de-risks the
scariest unknown (native-library bundling) up front.

### 🧰 Dev experience

- ✅ [FIBR-0001] **P01: project skeleton + lint + format
  + test + security-scan harness.** `pyproject.toml` (Python
  3.12+), `pip`+`venv` dev env, `ruff check` and `ruff format
  --check` clean on placeholder source, `pytest` exits 0 on an
  empty suite, **`bandit`, `pip-audit`, and `gitleaks` exit 0**.
  `.github/workflows/ci.yml` runs the same gates, and
  `scripts/ci-local.sh` mirrors them one-for-one (single source
  of truth for the gate list) so issues are caught before
  pushing. Dependencies: none. Lanes: build, ci, tests,
  security. Kind: chore. Source: planned.
  Resolved (2026-07-01): closed by /close-phase. Local gate exits 0; CI green in 23s; INV-1..INV-6 all demonstrated (INV-5 secret-injection demo flipped gitleaks + bandit red, then green on removal). /audit + /indie-review both returned zero actionable findings on the same pass. Impl commit 6b6ac64; tag FIBR-0001-complete.

- ✅ [FIBR-0002] **P01: `.gitignore` + secret-leak
  guard.** Standard Python ignore set (build artefacts,
  `.venv`, `__pycache__`, dep caches, IDE/OS files) plus
  explicit ignores for any local vault/`*.db`/`*.dmg`/AppImage
  build output, so **no financial data or build secret can ever
  be staged**. `gitleaks` (from FIBR-0001) is the backstop.
  Dependencies: FIBR-0001. Lanes: build, security. Kind: chore.
  Source: planned.
  Resolved 2026-07-01: .gitignore extended to block financial data (*.db/*.sqlite/*.sqlite3 + SQLite -wal/-shm/-journal sidecars) and build/packaging/tooling output; regression-locked by tests/features/gitignore/ (INV-1..INV-3 via git check-ignore --no-index). Spec cold-eyes-clean (4 loops); /audit + /indie-review zero actionable on the close pass (one indie-review LOW — global-git-excludes coupling — fixed inline). Full ci-local.sh gate green. Tag FIBR-0002-complete.

### 📦 Packaging

- 📋 [FIBR-0003] **P01: bundling smoke-test (de-risk
  native libs early).** Freeze the trivial placeholder app into
  a one-file **AppImage** *and* a PyInstaller bundle, then launch
  each on a clean target with **no Python installed**, confirming
  the CPython runtime + a stub SQLCipher/Qt load. This surfaces
  the native-lib collection risk named in ADR-0007 *now*, not
  after ten phases are built on top. Full multi-platform
  packaging + publish pipeline is deferred to P13. Dependencies:
  FIBR-0001. Lanes: build, ci. Kind: chore. Source: planned.

---

## P02 — Vertical slice: the security spine (target: after P01)

**Theme:** the smallest end-to-end feature that touches every
layer — and deliberately the **encrypted-storage spine**, since
security is the load-bearing concern. Proves UI → service →
repository → encrypted vault → output → test before any feature
lands on top.

### 🔒 Security

- 📋 [FIBR-0004] **P02: master password → encrypted vault
  → one manual transaction → table → lock.** First-run sets the
  master password + base currency; `CryptoService` derives the
  key with **Argon2id** (parameters pinned in security-model.md
  INV-2) and
  opens the **SQLCipher** (AES-256) vault; `AuthService`
  unlocks/locks and wipes the key from memory on lock; the user
  manually enters one transaction (through a repository, in a
  single DB transaction) and sees it in a table; locking returns
  to the unlock screen and the on-disk file is unreadable
  without the password. Verifies the whole security model
  (ADR-0003 + docs/security-model.md) concretely. Dependencies:
  FIBR-0001. (FIBR-0002 and FIBR-0003 also complete P01 first by
  phase-ordering, but are not direct code prerequisites of the
  vault.) Lanes: ui, services, repo, security, tests. Kind:
  implement. Source: planned.

---

## P03 — Accounts

### 🎨 Features

- 📋 [FIBR-0005] **P03: multiple accounts per profile.**
  Account model + CRUD + accounts-manager UI; each account
  tagged with a type (current, savings, credit card, personal
  loan, home loan, investment, other). Transactions belong to an
  account — this must exist before any import. Dependencies:
  FIBR-0004. Lanes: ui, services, repo, tests. Kind: implement.
  Source: planned.

---

## P04 — Category tree

### 🎨 Features

- 📋 [FIBR-0006] **P04: Type → Category tree (3rd level
  ready).** Self-referential `categories` table (`parent_id`),
  seeded Income/Expenditure types with sensible default
  categories (salary, sales / fast food, bills, medical,
  lottery…), and a category-management UI exposing two levels.
  Data model supports a future Sub-category level without
  migration. Dependencies: FIBR-0004. Lanes: services, repo, ui,
  tests. Kind: implement. Source: planned.

---

## P05 — CSV import + mapping profiles

### 🎨 Features

- 📋 [FIBR-0007] **P05: CSV import with per-bank mapping
  profiles + dedup + import wizard.** `ImportService`
  orchestration + `CsvImporter` + saved per-bank column-mapping
  profiles (ADR-0005); de-duplication so re-importing an
  overlapping statement adds **zero** duplicates (success
  criterion 2); import wizard with a preview that shows per-row
  parse errors *before* anything is written. The first real
  import path; establishes the pipeline P06/P07 reuse.
  Dependencies: FIBR-0005, FIBR-0006. Lanes: services, importers, ui,
  repo, tests. Kind: implement. Source: planned.

---

## P06 — OFX import

### 🎨 Features

- 📋 [FIBR-0008] **P06: OFX import.** `OfxImporter` via
  `ofxparse`, feeding the same `ImportService` pipeline (dedup,
  categorisation, transfer detection) built in P05. OFX is a
  worldwide standard needing no mapping profile. Dependencies:
  FIBR-0007. Lanes: importers, services, tests. Kind: implement.
  Source: planned.

---

## P07 — PDF statement import (incl. locked PDFs)

### 🎨 Features · 🔒 Security

- 📋 [FIBR-0009] **P07: PDF statement import with
  in-memory decrypt.** `PdfImporter` (`pdfplumber` text/table
  extraction) on the P05 pipeline; password-protected statements
  are decrypted **in memory only** (`pikepdf`, never written
  decrypted to disk); opt-in "remember this password" stores it
  **encrypted in the vault** against the account (default:
  prompt each time, store nothing). A wrong PDF password
  re-prompts rather than aborting the import. Dependencies: FIBR-0007.
  Lanes: importers, services, security, ui, tests. Kind:
  implement. Source: planned.

---

## P08 — Auto-categorisation rules

### 🎨 Features

- 📋 [FIBR-0010] **P08: rules engine + manual override.**
  `CategorizationService` applies a user-editable rule set to
  auto-assign categories; a manual override is the
  highest-priority signal and is never clobbered by re-import or
  a later rule. Rules-manager UI to view/add/edit. Dependencies:
  FIBR-0006, FIBR-0007. Lanes: services, ui, repo, tests. Kind: implement.
  Source: planned.

---

## P09 — Transfer detection

### 🎨 Features

- 📋 [FIBR-0011] **P09: transfer detection
  (suggest-then-confirm).** `TransferDetectionService` matches a
  debit in one account against a credit in another (same amount,
  short date window) and **proposes** the pair; only
  user-confirmed pairs are linked as transfers and excluded from
  income/expenditure totals (success criterion 3, ADR-0006).
  Rejected pairs are remembered so they don't re-surface. Never
  auto-hides a real expense. Dependencies: FIBR-0005, FIBR-0007. Lanes:
  services, ui, repo, tests. Kind: implement. Source: planned.

---

## P10 — Reporting + dashboard

### 🎨 Features

- 📋 [FIBR-0012] **P10: dashboard — summary, pie/donut,
  trends, filterable table.** `ReportingService` aggregates by
  category / account / period; the dashboard shows the
  income-vs-expenditure summary, a category pie/donut, and
  month-to-month trends, per account or consolidated; the
  transaction table gains full search + filters (success
  criterion 1). **Charts library is chosen at spec time**
  (QtCharts vs matplotlib vs pyqtgraph — must be dark-themeable
  *and* render into the PDF) and recorded as an ADR. Dependencies:
  FIBR-0008, FIBR-0009, FIBR-0010, FIBR-0011 (OFX, PDF, rule-based
  categorisation, and **transfer detection** — so the consolidated
  income/expenditure totals correctly exclude transfers, SC3; CSV via
  FIBR-0007 is pulled in transitively, so all of CSV/OFX/PDF are
  consolidated — SC1 names all three). Lanes: services, ui, tests. Kind: implement.
  Source: planned.

---

## P11 — Password-protected PDF export

### 🎨 Features · 🔒 Security

- 📋 [FIBR-0013] **P11: locked PDF export with section
  selection.** `PdfExportService` renders chosen sections
  (summary / charts / transactions) for a chosen period via the
  Qt PDF engine, then encrypts with a password set at export
  time (`pikepdf`, AES-256). Export dialog ticks sections + picks
  period + sets password (success criterion 5). Dependencies:
  FIBR-0012. Lanes: services, ui, security, tests. Kind: implement.
  Source: planned.

---

## P12 — Settings, auto-lock, backup, theme polish

### 🔒 Security · 🎨 Features

- 📋 [FIBR-0014] **P12: settings, inactivity auto-lock,
  encrypted backup.** Settings screen (base currency display,
  auto-lock timeout, manage stored PDF passwords, theme);
  inactivity **auto-lock** drops the key and returns to unlock;
  **encrypted backup export/import** (the only mitigation for a
  forgotten master password, per ADR-0003); dark-theme polish
  pass. Dependencies: FIBR-0004. Lanes: ui, services, security, tests.
  Kind: implement. Source: planned.

---

- 📋 [FIBR-0017] **P12: multi-language UI (i18n) — 6 bundled locales incl. RTL + language switcher.**
  Qt translation pipeline: every user-facing string is wrapped in `tr()` from the first UI onward (P02), `lupdate` extracts them to `.ts` catalogs, translations are compiled to `.qm` and loaded via `QTranslator` at startup and on live switch. Ships **6 locales**: English (base), Spanish, Simplified Chinese, Hindi, French, and **Arabic** (right-to-left). A language picker in the FIBR-0014 Settings screen switches locale. Numbers, currency, and dates render through `QLocale` (matters for a finance app — ties into the base-currency display), not hardcoded formats. The UI is built **RTL-ready** (layout mirroring) from P02 per design.md "Internationalization (i18n) & localisation", so Arabic is translate-and-ship; further RTL scripts (Hebrew, Urdu) are then a translation-only follow-up. NOTE: this stays cheap only if the string-externalization and RTL-safe-layout conventions are followed from P02 — retrofitting hardcoded English (and left-to-right-only layouts) across the whole feature stack is far more expensive. Dependencies: FIBR-0014 (settings screen hosts the switcher; transitively pulls the feature-complete UI so all strings exist to translate).
  **Layman:** Lets people use finbreak in their own language — ships in 6 languages to start (including Arabic, which reads right-to-left), with more addable later.
  Kind: implement.
  Lanes: ui, i18n, services, tests.
  Source: user-request-2026-07-01.

## P13 — Packaging & release

### 📦 Packaging

- 📋 [FIBR-0015] **P13: self-contained multi-platform
  builds.** PyInstaller → Windows `.exe` and unsigned macOS
  `.app` in a `.dmg`; **AppImage** (built on an old base image
  for glibc compatibility); **Flatpak** manifest for Flathub.
  Each artifact bundles the CPython runtime and **all** native
  deps (SQLCipher, the needed Qt plugins, qpdf); the **exit
  criterion** is a launch on a clean VM/container with **no
  Python installed** (ADR-0007). Builds on the P01 smoke-test.
  Dependencies: FIBR-0013, FIBR-0014, FIBR-0003 (direct
  predecessors). Walking the dependency edges, FIBR-0013 and
  FIBR-0014 transitively pull in the entire P02–P12 feature stack
  (FIBR-0004 through FIBR-0012), so P13 cannot start until the app
  is feature-complete. Lanes: build, ci, packaging.
  Kind: chore. Source: planned.

- 📋 [FIBR-0016] **P13: `scripts/publish-release.sh` +
  release automation.** One committed script builds every
  artifact above, publishes the GitHub Release, and drives the
  Flathub submission/update — consuming the Flathub manifest
  produced by FIBR-0015. It is itself a specced item (its own
  `docs/specs/`, cold-eyes-reviewed) — a publish script can't
  predate the thing it publishes. Dependencies: FIBR-0015. Lanes:
  build, ci, packaging. Kind: chore. Source: planned.

---

## Enhancements & performance backlog

Ideas captured 2026-07-01 from a product / performance review
(user-requested). Not yet slotted into the P0x phase order — each
carries a **Target phase** and `Dependencies:`; it is promoted into that
phase when its dependencies land. Two are **foundational** (marked
*Sequencing*) and must be designed at the noted phase, not deferred,
because retrofitting them is a data migration.

### 🔒 Security & account recovery

- 📋 [FIBR-0018] **Encrypted vault backup & restore.**
  Export the whole vault to a single encrypted backup file the user
  keeps off-device (external drive / cloud), and restore from it — the
  mitigation design.md names for the no-recovery-backdoor rule, so a disk
  failure or lost laptop doesn't mean lost data. Target phase: P12 (its
  heading already lists "backup"). Dependencies: FIBR-0004. Lanes:
  crypto, ux. Kind: feature. Source: user-request-2026-07-01.

- 📋 [FIBR-0019] **Master-password recovery via recovery key
  (key-wrapping).** At vault creation, generate a high-entropy recovery
  code the user stores safely; wrap the vault data-key under **both** the
  master password and the recovery code (envelope encryption) so a
  forgotten password is recoverable via the code with **no** backdoor.
  *Sequencing:* foundational — the key envelope must exist at FIBR-0004
  (vault creation); retrofitting needs a full re-encrypt migration.
  Requires an ADR + a security-model.md update at spec time. Target
  phase: P02. Dependencies: FIBR-0004. Lanes: crypto, security.
  Kind: security. Source: user-request-2026-07-01.

- 📋 [FIBR-0020] **Biometric unlock (fingerprint / face) with capability
  detection.** Store a key-wrapped copy of the vault key in the OS secure
  keystore, released by the platform biometric (Windows Hello, macOS
  Touch ID, Linux fprintd where present). **Detect** availability per-OS
  and offer it only when present; always keep the password as fallback. A
  convenience unlock, **not** a recovery method — Linux biometric support
  is uneven, so degrade gracefully. Target phase: P12. Dependencies:
  FIBR-0004, FIBR-0019 (shares the key-wrapping envelope). Lanes: crypto,
  platform, ux. Kind: feature. Source: user-request-2026-07-01.

### 🎨 Features & accessibility

- 📋 [FIBR-0021] **Multi-currency decision (ADR).** Decide single- vs
  multi-currency for v1 **before** accounts are built. If multi: a
  currency column on accounts/transactions, QLocale-formatted display,
  and a rule that the dashboard never sums across currencies without
  conversion. *Sequencing:* decide before FIBR-0005 (accounts) — adding a
  currency column afterwards is a schema migration. Target phase: P03
  (the decision precedes it). Dependencies: none. Lanes: data.
  Kind: investigate. Source: user-request-2026-07-01.

- 📋 [FIBR-0022] **Budgets + recurring / subscription detection.**
  Per-category monthly spending limits with progress + over-budget
  signalling on the dashboard, plus automatic detection of repeating
  charges (same payee / amount cadence) so subscriptions surface. Target
  phase: P10. Dependencies: FIBR-0006 (category tree), FIBR-0010 (rules).
  Lanes: reporting, ux. Kind: feature. Source: user-request-2026-07-01.

- 📋 [FIBR-0023] **Theming: light / dark + colourblind-safe palettes +
  picker.** Beyond the default dark theme (ADR-0002), add a light theme
  and colourblind-safe palettes, selectable from the FIBR-0014 Settings
  screen (beside the FIBR-0017 language picker); dashboard charts
  (FIBR-0012) draw series colours from the active palette so colourblind
  users get distinguishable series. Target phase: P12. Dependencies:
  FIBR-0012, FIBR-0014. Lanes: ui, accessibility. Kind: ux.
  Source: user-request-2026-07-01.

- 📋 [FIBR-0024] **Accessibility: keyboard navigation + screen-reader
  support.** Full keyboard control (focus order, shortcuts, no mouse-only
  actions) and screen-reader labels/roles via Qt accessibility
  (`QAccessible`) on widgets and charts. Pairs with the i18n/RTL
  (FIBR-0017) and theming (FIBR-0023) work. Target phase: P12.
  Dependencies: FIBR-0014. Lanes: ui, accessibility. Kind: accessibility.
  Source: user-request-2026-07-01.

### ⚡ Performance

- 📋 [FIBR-0025] **Enable SQLite WAL mode.** Set
  `PRAGMA journal_mode=WAL` on the SQLCipher DB for better write
  throughput and UI responsiveness during import. *Sequencing:* set at DB
  creation (FIBR-0004). WAL adds `-wal` / `-shm` sidecars (already
  ignored by FIBR-0002; SQLCipher encrypts them too). Target phase: P02.
  Dependencies: FIBR-0004. Lanes: persistence, perf. Kind: perf.
  Source: user-request-2026-07-01.

- 📋 [FIBR-0026] **Index the import de-duplication lookup.** Add a DB
  index on `(account_id, date, amount)` (and/or a normalised-description
  hash column) so import dedup (design.md data-flow step 5) is an indexed
  lookup, not an O(n·m) scan of existing rows for every imported row.
  Target phase: P05. Dependencies: FIBR-0007. Lanes: data, perf.
  Kind: perf. Source: user-request-2026-07-01.

- 📋 [FIBR-0027] **SQL-side dashboard aggregation + incremental refresh.**
  Compute dashboard summaries / charts with SQL `GROUP BY` rather than
  Python loops, and refresh incrementally on a single-row edit instead of
  a full recompute; add supporting indexes (`date`, `category_id`). Keeps
  the dashboard fast at tens of thousands of transactions. Target phase:
  P10. Dependencies: FIBR-0012. Lanes: reporting, perf. Kind: perf.
  Source: user-request-2026-07-01.

- 📋 [FIBR-0028] **Virtual table model for the transaction list.** Back
  the transaction table with a `QAbstractTableModel` (lazy / virtual
  rows) rather than per-row widgets, so a large history scrolls smoothly.
  Target phase: P10. Dependencies: FIBR-0012. Lanes: ui, perf.
  Kind: perf. Source: user-request-2026-07-01.

---

## How to add an item

1. Allocate the next ID:
   ```bash
   echo $(($(cat .roadmap-counter) + 1)) > .roadmap-counter
   printf "FIBR-%04d\n" $(cat .roadmap-counter)
   ```
2. Insert at the **position** where it should be tackled (not
   blindly at the end).
3. Set the status emoji (📋 Planned, 💭 Considered).
4. Add `Lanes:` line declaring ownership.
5. Add `Kind:` (required on every bullet, per
   `roadmap-format.md § 3.5`) and `Source:` (omit only when it's
   `planned`).

See `docs/standards/roadmap-format.md § 3.5` for the full bullet
contract.

## How findings get folded

After every `/audit` + `/indie-review` (and `/debt-sweep`):

```
Phase closes
  → Run /audit + /indie-review
  → Triage findings
  → If clean: phase fully closed.
  → If actionable: batch into one new fix-pass FP## (next-up),
    add [Unreleased] entry, run that fix-pass through the
    9-step loop; its own closing audits may produce another.
```

See `docs/standards/roadmap-format.md § 3.8` and the
[app-workflow skill](~/.claude/skills/app-workflow/SKILL.md)
for the full pattern.
