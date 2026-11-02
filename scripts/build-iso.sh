#!/bin/sh
set -eu

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build"
OUTPUT="$BUILD_DIR/CarsonOS-Debian-amd64.iso"

if [ "$(id -u)" -ne 0 ]; then
    echo "Run this script with sudo/root: sudo ./scripts/build-iso.sh" >&2
    exit 1
fi

for command in lb xorriso mksquashfs; do
    if ! command -v "$command" >/dev/null 2>&1; then
        echo "Missing build dependency: $command" >&2
        echo "Install live-build, xorriso, and squashfs-tools first." >&2
        exit 1
    fi
done

cd "$ROOT_DIR"
mkdir -p "$BUILD_DIR"

# A clean build avoids stale package indexes and previous generated config.
lb clean --purge || true
rm -f "$ROOT_DIR"/live-image-amd64.hybrid.iso
rm -f "$ROOT_DIR"/live-image-amd64.contents "$ROOT_DIR"/live-image-amd64.packages

lb config
lb build

ISO="$ROOT_DIR/live-image-amd64.hybrid.iso"
if [ ! -s "$ISO" ]; then
    echo "Build completed without the expected ISO: $ISO" >&2
    exit 1
fi

cp "$ISO" "$OUTPUT"
sha256sum "$OUTPUT" > "$OUTPUT.sha256"
echo
echo "CarsonOS Debian ISO created:"
echo "  $OUTPUT"
echo "Checksum:"
cat "$OUTPUT.sha256"
