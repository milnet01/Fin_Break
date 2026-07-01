"""FIBR-0003 INV-1 — ``python -m finbreak`` entry point.

At P01 the only real mode is ``--self-test`` (the native-stack smoke check);
with no arguments it prints a placeholder notice, since no GUI exists yet. The
real GUI entry point lands from P02. ``--self-test`` is a **permanent**
diagnostic mode — it survives as a way to check a broken install on a user's
machine. See docs/specs/FIBR-0003.md.
"""

from __future__ import annotations

import sys

from finbreak import _selftest


def main(argv: list[str] | None = None) -> int:
    args = sys.argv[1:] if argv is None else argv
    if args == ["--self-test"]:
        return _selftest.run_self_test()
    if not args:
        print("finbreak is not built yet — no GUI at P01. Try --self-test.")
        print("FINBREAK_NOT_BUILT")
        return 0
    print(f"finbreak: unrecognised arguments {args!r}", file=sys.stderr)
    return 2


if __name__ == "__main__":
    sys.exit(main())
