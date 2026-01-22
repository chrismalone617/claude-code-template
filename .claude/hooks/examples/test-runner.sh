#!/bin/bash

# Test Runner Hook Example
# This hook runs tests after Claude makes changes to test files
#
# To use this hook, add to .claude/settings.json:
# {
#   "hooks": {
#     "afterEdit": ".claude/hooks/test-runner.sh"
#   }
# }

set -e

# The file that was edited is passed as an argument
FILE="$1"

# Only run tests if a test file was edited
if [[ "$FILE" != *".test."* ]] && [[ "$FILE" != *".spec."* ]]; then
  echo "Not a test file, skipping test run"
  exit 0
fi

echo "Test file modified: $FILE"
echo "Running tests..."

# Get file extension
EXT="${FILE##*.}"

# Run tests based on file type
case "$EXT" in
  ts|tsx|js|jsx)
    # Run JavaScript/TypeScript tests
    if [ -f "package.json" ]; then
      # Try to run just the specific test file
      if command -v jest &> /dev/null; then
        jest "$FILE"
      elif command -v vitest &> /dev/null; then
        vitest run "$FILE"
      else
        # Fall back to npm test
        npm test -- "$FILE"
      fi
      echo "✓ Tests passed"
    else
      echo "⚠ No package.json found"
      exit 0
    fi
    ;;

  py)
    # Run Python tests
    if command -v pytest &> /dev/null; then
      pytest "$FILE" -v
      echo "✓ Tests passed"
    else
      echo "⚠ pytest not found"
      exit 0
    fi
    ;;

  go)
    # Run Go tests
    if command -v go &> /dev/null; then
      # Get the directory of the test file
      TEST_DIR=$(dirname "$FILE")
      go test "$TEST_DIR" -v
      echo "✓ Tests passed"
    else
      echo "⚠ go command not found"
      exit 0
    fi
    ;;

  *)
    echo "No test runner configured for .$EXT files"
    exit 0
    ;;
esac

exit 0
