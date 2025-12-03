#!/usr/bin/env bash
set -euo pipefail

# Build the Docker image defined in builds/ubuntu/Dockerfile and copy the
# resulting postgresql95-hashlib.<arch>.tar.gz from the image to the host.
PGVER=${1:-95} # options are 95, 12, 15 or 18

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR%/builds/ubuntu}"
DOCKERFILE_PATH="$SCRIPT_DIR/$PGVER/Dockerfile"
IMAGE_TAG="pghashlib:pg${PGVER}"
OUTPUT_DIR="$SCRIPT_DIR"

cat << INFO
SCRIPT_DIR = $SCRIPT_DIR
REPO_ROOT = $REPO_ROOT
DOCKERFILE_PATH = $DOCKERFILE_PATH
IMAGE_TAG = $IMAGE_TAG
OUTPUT_DIR = $OUTPUT_DIR
INFO

echo "Building Docker image: $IMAGE_TAG"
docker build -f "$DOCKERFILE_PATH" -t "$IMAGE_TAG" "$REPO_ROOT"

echo "Discovering artifact name from a one-off container"
# Run a short-lived container only to list the artifact and get its basename
ARTIFACT_NAME="$(
  docker run --rm "$IMAGE_TAG" sh -lc "ls -1 /postgresql$PGVER-hashlib*.tar.gz 2>/dev/null | head -n1 | xargs -n1 basename"
)"

if [[ -z "$ARTIFACT_NAME" ]]; then
  echo "Error: Could not find artifact '/postgresql$PGVER-hashlib*.tar.gz' inside the image." >&2
  echo "Hint: Ensure the Dockerfile produces the tarball at the image root during build." >&2
  exit 1
fi

DEST_PATH="$OUTPUT_DIR/$ARTIFACT_NAME"

echo "Creating a stopped container to copy the artifact"
CID="$(docker create "$IMAGE_TAG")"
cleanup() {
  docker rm -f "$CID" >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "Copying artifact /$ARTIFACT_NAME to $DEST_PATH"
docker cp "$CID:/$ARTIFACT_NAME" "$DEST_PATH"

echo "Success: Artifact copied to $DEST_PATH"
