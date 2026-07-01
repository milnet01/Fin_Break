#!/usr/bin/env bash
# FIBR-0003 — bundling smoke-test: prove the three NATIVE stacks (Qt via
# PySide6, the SQLCipher library, and qpdf behind pikepdf) freeze into a
# portable Linux artifact and run with NO Python installed.
#
# Builds a PyInstaller --onefile AND an AppImage of `python -m finbreak
# --self-test` inside a manylinux_2_34 container (so the glibc floor is bounded
# to the container's, not the bleeding-edge build host), then launches each
# inside a Python-free debian:13-slim container with a scrubbed, offline
# environment and asserts FINBREAK_SELFTEST_OK. Exits 0 only if BOTH pass.
#
# This is the opt-in build stage FIBR-0001 promised ci-local.sh would gain; it
# is NOT part of the everyday fast gate. See docs/specs/FIBR-0003.md.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIST="$ROOT/dist"
CACHE="$DIST/.build-cache"
BUILD_IMAGE="docker.io/library/python:3.12-slim-bookworm"
TEST_IMAGE="docker.io/library/debian:13-slim"
CLEANROOM_IMAGE="localhost/finbreak-cleanroom:13"
ONEFILE="finbreak-selftest"
APPIMAGE="finbreak-selftest-x86_64.AppImage"
SENTINEL="FINBREAK_SELFTEST_OK"
CONTAINER_PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# --- pick a container runtime (podman preferred; docker fallback) -----------
if command -v podman >/dev/null 2>&1; then
    RUNNER=podman
elif command -v docker >/dev/null 2>&1; then
    RUNNER=docker
else
    echo "build-smoke: no container runtime (podman/docker) on PATH" >&2
    exit 1
fi
echo "== build-smoke: runner=$RUNNER =="

mkdir -p "$DIST" "$CACHE"

# --- 1) build both artifacts inside the manylinux_2_34 container ------------
# The build phase needs network (pip + appimagetool fetch); only the run phase
# (step 2) is offline.
echo "== build-smoke: freezing in $BUILD_IMAGE (this takes a few minutes) =="
# label=disable: this host labels bind mounts (container-selinux present) so a
# plain :ro mount is unreadable inside the container; disabling per-container
# labeling fixes the read without relabelling the host tree. No-op under Docker.
"$RUNNER" run --rm \
    --security-opt label=disable \
    -v "$ROOT":/src:ro \
    -v "$DIST":/out \
    -v "$CACHE":/cache \
    -e "ONEFILE=$ONEFILE" \
    -e "APPIMAGE=$APPIMAGE" \
    "$BUILD_IMAGE" bash /src/scripts/_build-smoke-in-container.sh

[ -x "$DIST/$ONEFILE" ] || { echo "build-smoke: onefile not produced" >&2; exit 1; }
[ -f "$DIST/$APPIMAGE" ] || { echo "build-smoke: AppImage not produced" >&2; exit 1; }

# --- prepare the clean-room image -------------------------------------------
# A minimal, Python-free target with the UNIVERSAL desktop graphics baseline
# (libGL/libEGL). Everything app-specific — CPython, Qt's glib/freetype/
# fontconfig/harfbuzz, SQLCipher, qpdf — travels INSIDE the bundle; libGL is the
# one lib PyInstaller (and every AppImage) leaves to the host, because it is
# driver-tied and present on every real desktop. Adding it here represents a
# real GUI-capable machine, not a bare container (FIBR-0003 INV-3).
echo "== build-smoke: preparing clean-room image ($TEST_IMAGE + graphics baseline) =="
printf 'FROM %s\nRUN apt-get update && apt-get install -y --no-install-recommends libgl1 libegl1 && rm -rf /var/lib/apt/lists/*\n' \
    "$TEST_IMAGE" | "$RUNNER" build -t "$CLEANROOM_IMAGE" -f - "$DIST" >/dev/null

# --- 2) clean-room: run each artifact in a Python-free, offline container ----
# Absence of an exact SENTINEL stdout line == failure (catches a loader crash
# that dies before printing anything).
run_clean_room() {
    local label="$1"
    shift
    echo "== build-smoke: clean-room [$label] in $CLEANROOM_IMAGE =="
    local out
    # No host env is inherited by `run` (the container env starts clean), so we
    # simply set the few vars the launch needs. --network=none keeps it offline.
    if ! out="$("$RUNNER" run --rm --network=none \
            --security-opt label=disable \
            -e "PATH=$CONTAINER_PATH" \
            -e "QT_QPA_PLATFORM=offscreen" \
            -e "APPIMAGE_EXTRACT_AND_RUN=1" \
            -v "$DIST":/artifact:ro \
            "$CLEANROOM_IMAGE" "$@" 2>&1)"; then
        printf '%s\n' "$out"
        echo "build-smoke: [$label] exited non-zero (see output above)" >&2
        return 1
    fi
    if ! printf '%s\n' "$out" | grep -Fxq "$SENTINEL"; then
        printf '%s\n' "$out"
        echo "build-smoke: [$label] did not print an exact $SENTINEL line" >&2
        return 1
    fi
    echo "build-smoke: [$label] OK"
}

run_clean_room "onefile" "/artifact/$ONEFILE" --self-test
run_clean_room "AppImage" "/artifact/$APPIMAGE" --self-test

echo "== build-smoke: PASS — both artifacts ran with no Python installed =="
