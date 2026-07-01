# Feature test contract — bundling smoke-test (FIBR-0003)

Governs `test_bundling.py`. Enforces `docs/specs/FIBR-0003.md`
INV-1 (the `--self-test` entry point) and INV-6 (the fast guard), plus
INV-2/INV-3 (the build + clean-room launch) via one gated integration test.

## Fast guard (dev venv — runs in the everyday gate, `features` marker)

Exercises the three entry-point modes of `python -m finbreak` (INV-1 table):

| Mode | Expected stdout line | Exit |
|------|----------------------|------|
| `--self-test`, all stacks load | `FINBREAK_SELFTEST_OK` | 0 |
| `--self-test`, a stack fails | `FINBREAK_SELFTEST_FAIL: <stack>` | non-zero |
| no args | `FINBREAK_NOT_BUILT` | 0 |

- **OK / no-args** run the real CLI as a subprocess (`python -m finbreak …`
  with `QT_QPA_PLATFORM=offscreen`), so they need the runtime deps installed;
  they assert the **exact** sentinel line and the exit code.
- **FAIL** is a unit test of `finbreak._selftest.run_self_test`: it
  monkeypatches the Qt check to pass and the SQLCipher check to raise, then
  asserts the emitted line is `FINBREAK_SELFTEST_FAIL: sqlcipher` (proving the
  ordered `<stack>` token, INV-1) and the return value is non-zero — so it is
  independent of whether the heavy native deps are installed.

## Build + clean-room (integration — `integration` marker, opt-in)

`test_build_clean_room` runs `scripts/build-smoke.sh` and asserts exit 0
(both artifacts print `FINBREAK_SELFTEST_OK` in the Python-free container,
INV-2/INV-3). It **skips** unless ALL hold, so the everyday gate never blocks
on a multi-minute build (INV-5/INV-6):

- `FINBREAK_BUILD_SMOKE=1` is set (the same opt-in switch as the build stage);
- `scripts/build-smoke.sh` exists;
- a container runtime (`podman` or `docker`) is on `PATH`.
