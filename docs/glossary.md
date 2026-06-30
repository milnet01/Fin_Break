# Fin_Break — Glossary

Domain-specific and workflow-specific terms used in code,
docs, and commits. If a term appears in `discovery.md`,
`design.md`, or any spec and a reader six months from now
might be confused, add it here.

The starter entries below cover terminology used by the
`app-workflow` skill itself; project-specific terms get added
during Phases B and C.

| Term | Definition |
|------|------------|
| **ADR** | Architecture Decision Record — a one-page note explaining a non-obvious design choice, the alternatives considered, and the reasoning. Lives in `docs/decisions/`. |
| **Discovery (Phase A)** | The conversational opening phase: Claude asks one question at a time about the problem, the people who'll use the result, and what "success" looks like. Output: `docs/discovery.md`. |
| **Vertical slice (P02)** | The smallest possible end-to-end feature that touches every layer (input → logic → storage → output → test). The point isn't user value; it's making integration pain surface before more code lands on top. |
| **Mermaid** | A tiny text-based diagram language. GitHub and most markdown viewers render it automatically — no separate tool to install. Used for architecture/flow diagrams in `design.md`. |
| **TDD** | Test-driven development. Write the failing test first, watch it fail for the right reason, then write the smallest code that makes it pass. If the test passes before code is written, the test isn't checking what you thought. |
| **Triage** | The process of sorting findings into three buckets: actionable (folds into a fix-pass), blocked-by-dependency (logs to `known-issues.md`), false-positive (logs to `audit-allowlist.md`). |
| **Lane** | A named subsystem owner (e.g. `build`, `ui`, `tests`, `docs`). Used in roadmap items so parallel subagents can find the right files; per `docs/standards/roadmap-format.md § 3.6.4`. |
| **Kind** | A roadmap-bullet metadata field declaring the work type (`implement`, `fix`, `refactor`, `audit-fix`, `review-fix`, `doc`, `doc-fix`, `test`, `chore`, `release`). Drives which standard governs the work; per `docs/standards/roadmap-format.md § 3.6.3`. |
| **Source** | A roadmap-bullet metadata field naming where the item came from (`audit`, `indie-review`, `debt-sweep`, `user`, `planned`); per `docs/standards/roadmap-format.md § 3.6.3`. |
| **Fix-pass (`FP##`)** | A roadmap item generated automatically after `/audit` + `/indie-review` to track findings as a single batched piece of work that runs through the full 9-step loop. |
| **Convergence checkpoint** | The fix-pass count (default 5) at which Claude pauses to ask whether to keep iterating, accept remaining findings into known-issues, or rethink design. Configurable in `.claude/workflow.md` § 1. |
| **Debt-sweep (`DS##`)** | A scan for cumulative drift introduced over multiple phases, run by `/debt-sweep`. Default cadence: as part of `/release` before the version bump. |

## Conventions

- **Bold the term** in its first use in this file.
- **One-line definition.** If a term needs more, link from the
  glossary entry to an ADR or design-doc subsection.
- **Append-only.** When a term is renamed, add the new term and
  mark the old one as `(retired in vX.Y.Z, see "<new name>")`.
- **Sort alphabetically** after the workflow-vocabulary block
  above. Helps lookup.
- **Link external sources** for terms with a canonical external
  definition (RFC, W3C spec, vendor docs).
