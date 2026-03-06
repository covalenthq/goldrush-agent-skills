#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <version>" >&2
  echo "Example: $0 v1.2.3" >&2
  exit 1
fi

VERSION="$1"

# Ensure we're on the main branch
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [ "$BRANCH" != "main" ]; then
  echo "Error: must be on the main branch (currently on '$BRANCH')" >&2
  exit 1
fi

# Ensure the working tree is clean
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Error: working tree is not clean. Commit or stash your changes first." >&2
  exit 1
fi

# Check for untracked files
if [ -n "$(git ls-files --others --exclude-standard)" ]; then
  echo "Warning: untracked files exist (proceeding anyway)"
fi

# Check the tag doesn't already exist
if git rev-parse "$VERSION" >/dev/null 2>&1; then
  echo "Error: tag '$VERSION' already exists" >&2
  exit 1
fi

git tag -a "$VERSION" -m "Release $VERSION"
echo "Tagged $VERSION at $(git rev-parse --short HEAD)"
echo "Run 'git push origin $VERSION' to publish the release."
