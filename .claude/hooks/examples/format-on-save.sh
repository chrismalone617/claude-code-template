#!/bin/bash

# Format-on-Save Hook Example
# This hook automatically formats files after Claude edits them
#
# To use this hook, add to .claude/settings.json:
# {
#   "hooks": {
#     "afterEdit": ".claude/hooks/format-on-save.sh"
#   }
# }

set -e

# The file that was edited is passed as an argument
FILE="$1"

# Check if file exists
if [ ! -f "$FILE" ]; then
  echo "File not found: $FILE"
  exit 0
fi

# Get file extension
EXT="${FILE##*.}"

echo "Formatting $FILE..."

# Format based on file type
case "$EXT" in
  ts|tsx|js|jsx|json)
    # Format with Prettier
    if command -v prettier &> /dev/null; then
      prettier --write "$FILE"
      echo "✓ Formatted with Prettier"
    else
      echo "⚠ Prettier not found, skipping format"
    fi
    ;;

  py)
    # Format Python files with Black
    if command -v black &> /dev/null; then
      black "$FILE"
      echo "✓ Formatted with Black"
    else
      echo "⚠ Black not found, skipping format"
    fi
    ;;

  go)
    # Format Go files
    if command -v gofmt &> /dev/null; then
      gofmt -w "$FILE"
      echo "✓ Formatted with gofmt"
    else
      echo "⚠ gofmt not found, skipping format"
    fi
    ;;

  rs)
    # Format Rust files
    if command -v rustfmt &> /dev/null; then
      rustfmt "$FILE"
      echo "✓ Formatted with rustfmt"
    else
      echo "⚠ rustfmt not found, skipping format"
    fi
    ;;

  *)
    echo "No formatter configured for .$EXT files"
    ;;
esac

exit 0
