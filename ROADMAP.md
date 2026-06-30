<!-- ants-roadmap-format: 1 -->
# Fin_Break — Roadmap

> **Current version:** 0.0.0 (scaffolded 2026-06-30). See
> [CHANGELOG.md](CHANGELOG.md) for what's shipped; this file
> covers what's **planned**.
>
> **Format:** v1 — see
> [docs/standards/roadmap-format.md](docs/standards/roadmap-format.md).
> Every actionable bullet carries a stable
> `fin_break-NNNN` ID alongside its phase ID
> (`P##`, `FP##`, `DS##`, `DOC##`, `R##`); the phase ID
> categorises blocks while the stable ID identifies individual
> bullets within them. ID is identity, position is priority,
> items are tackled top-to-bottom.

**Legend** (per `docs/standards/roadmap-format.md § 3.4`)

- ✅ Done (shipped)
- 🚧 In progress (being tackled now)
- 📋 Planned (next up for this phase)
- 💭 Considered (research phase; scope or feasibility uncertain)

**Themes** (per `docs/standards/roadmap-format.md § 3.5`)

- 🎨 Features · ⚡ Performance · 🔌 Plugins · 🖥 Platform
- 🔒 Security · 🧰 Dev experience · 📚 Documentation
- 📦 Packaging · 🐛 Bug fixes · 🔍 Findings fold-in
- 🧹 Cleanup / debt

---

## P01 — Bootstrap (target: TBD, set after Phase A)

**Theme:** wire up the build, lint, format, test, and CI
plumbing chosen during Phase A discovery. Zero user-facing
features. Forces the audit harness to be known-working before
any business code lands.

### 🧰 Dev experience

- 📋 [fin_break-1001] **P01: build system + linter +
  formatter + test harness wired up.** Hello-world build passes,
  `<test-runner>` exits 0 on an empty suite, `<linter>` exits 0
  on the placeholder source, `<formatter> --check` exits 0,
  `<ci-config>` files committed. Tech-stack-specific commands
  filled in once Phase A names the stack. Dependencies: none.
  Lanes: build, ci, tests.

- 📋 [fin_break-1002] **P01: `.gitignore` populated
  per language.** Today the file ships empty as a template
  placeholder; this item adds the standard ignore set for the
  Phase-A-chosen stack (build artefacts, dep caches, IDE
  files, OS files, secret-bearing dotfiles).
  Dependencies: 1001 (the build system has to exist first to
  know what to ignore). Lanes: build.

---

## P02 — Vertical slice (target: after P01 closes)

**Theme:** smallest possible end-to-end feature (input → logic
→ storage if any → output → test). Forces all integration pain
to surface before more code lands on top. Specific feature
choice deferred to Phase A discovery output.

### 🎨 Features

- 📋 [fin_break-1003] **P02: vertical slice — TBD
  feature.** Filled in during Phase C from the success-criteria
  list in `docs/discovery.md`. Dependencies: P01 closed.
  Lanes: TBD.

---

## Future phases

Phases P03 and onward come from `docs/discovery.md § Success
criteria`. Phase C documentation captures them with full bodies
and Kind/Source metadata.

---

## How to add an item

1. Allocate the next ID:
   ```bash
   echo $(($(cat .roadmap-counter) + 1)) > .roadmap-counter
   printf "fin_break-%04d\n" $(cat .roadmap-counter)
   ```
2. Insert at the **position** where it should be tackled (not
   blindly at the end).
3. Set the status emoji (📋 Planned, 💭 Considered).
4. Add `Lanes:` line declaring ownership.
5. Add `Kind:` and `Source:` if they're not obvious from the
   section heading.

See `docs/standards/roadmap-format.md § 3.6` for the full bullet
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

See `docs/standards/roadmap-format.md § 3.9` and the
[app-workflow skill](~/.claude/skills/app-workflow/SKILL.md)
for the full pattern.
