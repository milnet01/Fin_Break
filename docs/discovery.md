# Fin_Break — Discovery (Phase A)

> **Status:** Template — filled during Phase A.
> **Phase:** A — Discovery.
> **Output:** problem, users, success criteria, tech stack,
> out of scope.
> **Gate:** user explicitly approves this document before
> Phase B starts.

The
[app-workflow skill](~/.claude/skills/app-workflow/SKILL.md)
guides Phase A as a conversation, one question at a time.
The questions and prompts below are a checklist — once each
section is filled with a sign-off-ready answer, this doc is
done.


## Problem

> *What hurt is this project addressing? Be specific. "Faster
> note-taking" is too vague; "I lose context between Claude
> Code sessions and have to re-explain my project every time"
> is the right level.*

(filled during Phase A)

## Users

> *1–3 personae, written as "a person who…" sentences.
> Concrete, not abstract. "A solo developer who…" beats
> "developers in general."*

1. (filled during Phase A)

## Success criteria

> *3–5 measurable outcomes that mark the project as
> "working" — not just "shipped." Each criterion is
> something you can demonstrate by doing, not just by
> looking at code.*

1. (filled during Phase A)
2. (filled during Phase A)
3. (filled during Phase A)

## Tech stack

> *Claude recommends; user accepts or redirects. Each choice
> comes with one sentence of reasoning + a one-sentence
> runner-up so the trade-offs are visible.*

| Layer | Choice | Why | Runner-up |
|-------|--------|-----|-----------|
| Language | TBD | TBD | TBD |
| Framework | TBD | TBD | TBD |
| Build / package | TBD | TBD | TBD |
| Test runner | TBD | TBD | TBD |
| Linter / formatter | TBD | TBD | TBD |
| CI | GitHub Actions (default) | Free for public repos; matches user's existing tooling | GitLab CI / Buildkite |
| License | MIT (default) | Permissive; matches scaffold | Apache-2.0 |

## Out of scope

> *What this project explicitly does NOT do. Empty section
> is OK — the heading itself is a useful question to answer.
> List things you considered and decided against, not things
> you never thought of.*

(filled during Phase A; empty list is OK)

## Distribution

> *Where will this project live? Drives optional-template
> activation and the push policy.*

- **Distribution:** local-only | private GitHub | public GitHub
- **Reason:**

If **public GitHub**, activate the GitHub-public optionals
during this phase per the
[app-workflow skill](~/.claude/skills/app-workflow/SKILL.md)
"Optional template activation" instructions — this adds
`CONTRIBUTING.md`, `.github/dependabot.yml`, issue templates,
and a PR template.

If **private GitHub**, the global `~/.claude/CLAUDE.md` § 6
batched-push rule applies (commit locally; push once 5+
commits/tags accrue).

## Sign-off

- [ ] Problem captured.
- [ ] Users captured (1–3 personae).
- [ ] Success criteria captured (3–5 measurable outcomes).
- [ ] Tech stack chosen with one-sentence reasoning each.
- [ ] Out-of-scope list captured (or explicitly empty).
- [ ] Distribution chosen (and optionals activated if applicable).
- [ ] **User has approved this document.** Date: ____.

Once approved, proceed to Phase B — `docs/design.md`.
