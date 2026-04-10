#!/usr/bin/env bash
# Imports Raycast settings whenever dot_config/raycast/settings.rayconfig changes.
# chezmoi runs this script automatically when the source file hash changes.
#
# To update: configure Raycast, then export via:
#   Raycast Settings → Advanced → Export
# Save the output as dot_config/raycast/settings.rayconfig and commit.

set -euo pipefail

SETTINGS="{{ .chezmoi.sourceDir }}/dot_config/raycast/settings.rayconfig"

if [[ ! -f "$SETTINGS" ]]; then
  echo "Raycast settings file not found at $SETTINGS — skipping import"
  exit 0
fi

open -a Raycast "$SETTINGS"
echo "Raycast settings import triggered — confirm the import in the Raycast dialog if prompted"
