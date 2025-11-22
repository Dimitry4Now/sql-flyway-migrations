#!/usr/bin/env bash
set -e

MIGRATIONS_DIR="sql/migrations"

missing_undos=0

for vfile in $(find "$MIGRATIONS_DIR" -type f -name "V*.sql"); do
  base=$(basename "$vfile")
  num=${base%%__*}
  num=${num#V}
  ufile=$(dirname "$vfile")/../undo/U${num}__$(echo "$base" | cut -d'__' -f2-)

  if [ ! -f "$ufile" ]; then
    echo "❌ Missing undo migration for: $base"
    missing_undos=$((missing_undos+1))
  fi
done

if [ "$missing_undos" -gt 0 ]; then
  echo "🚫 Validation failed: $missing_undos undo migrations missing."
  exit 1
else
  echo "✅ All versioned migrations have corresponding undo migrations."
fi
