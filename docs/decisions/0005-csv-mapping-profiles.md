# ADR-0005: Generic per-bank CSV mapping profiles over hard-coded parsers

- **Status:** Accepted
- **Date:** 2026-06-30
- **Deciders:** Project lead, Claude
- **Related:** [docs/discovery.md](../discovery.md) (users 1 & 2)

## Context

The app must accept statements from **any bank in any country** — the user
banks with Standard Bank and Absa, but friends and worldwide users could be on
any institution. CSV exports have no universal schema: column order, names,
date formats, and how the amount is represented (single signed column vs
separate debit/credit columns) all vary by bank.

Options:

- **Hard-coded per-bank parsers** — accurate for known banks, but unbounded
  maintenance and useless for the next user's unknown bank. Rejected.
- **Auto-detect columns heuristically** — fragile; silent mis-mapping of a
  financial figure is unacceptable.
- **User-defined mapping profiles** — on first import of a given CSV shape, the
  user maps columns (date, description, amount or debit/credit, date format)
  once; the mapping is saved and reused automatically for that bank.

OFX, being a standardised format, is parsed generically and needs no profile.

## Decision

Import CSV via **reusable mapping profiles**: a one-time, user-confirmed
column/format mapping per bank layout, stored in the encrypted DB and matched
to future imports. No bank is hard-coded. A preview step shows parsed rows
before anything is saved.

## Consequences

**Positive:**

- Works for any bank, any country, with no code changes.
- The preview + explicit mapping prevents silent mis-parsing of amounts.

**Negative:**

- First import of a new layout costs the user a short mapping step.
- Profile-matching (recognising "this file is the layout I mapped before") needs
  a stable signature (header row / column fingerprint).

**Neutral:**

- Ships with a couple of starter profiles (e.g. a common Standard Bank / Absa
  CSV shape) as conveniences, but these are data, not code paths.
