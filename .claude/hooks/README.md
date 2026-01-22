# Hooks Directory

This directory contains hook scripts that run automatically at specific points in Claude Code's execution.

## What are Hooks?

Hooks are shell scripts that execute automatically when certain events occur:
- Before/after reading files
- Before/after writing files
- Before/after editing files
- Before/after git operations

## Directory Structure

```
hooks/
├── README.md           # This file
└── examples/
    ├── format-on-save.sh
    └── test-runner.sh
```

## Available Hooks

### File Operations
- `beforeRead` - Before Claude reads a file
- `afterRead` - After Claude reads a file
- `beforeWrite` - Before Claude writes a new file
- `afterWrite` - After Claude writes a new file
- `beforeEdit` - Before Claude edits an existing file
- `afterEdit` - After Claude edits an existing file

### Git Operations
- `beforeCommit` - Before creating a git commit
- `afterCommit` - After creating a git commit
- `beforePush` - Before pushing to remote
- `afterPush` - After pushing to remote

## Configuring Hooks

Hooks are configured in `.claude/settings.json`:

```json
{
  "hooks": {
    "afterEdit": ".claude/hooks/format-on-save.sh",
    "afterWrite": ".claude/hooks/test-runner.sh",
    "beforeCommit": ".claude/hooks/pre-commit.sh"
  }
}
```

## Creating Hooks

### Basic Hook

Create a shell script in `.claude/hooks/`:

```bash
#!/bin/bash
# my-hook.sh

# File path is passed as first argument
FILE="$1"

echo "Hook running on: $FILE"

# Do something with the file
# ...

exit 0
```

Make it executable:
```bash
chmod +x .claude/hooks/my-hook.sh
```

Configure in `.claude/settings.json`:
```json
{
  "hooks": {
    "afterEdit": ".claude/hooks/my-hook.sh"
  }
}
```

### Hook with Validation

```bash
#!/bin/bash
set -e

FILE="$1"

# Validate file exists
if [ ! -f "$FILE" ]; then
  echo "Error: File not found: $FILE"
  exit 1
fi

# Process file
echo "Processing $FILE..."

# Success
exit 0
```

## Example Hooks

### Format on Save

Automatically format files after editing:

```bash
#!/bin/bash
# format-on-save.sh

set -e

FILE="$1"
EXT="${FILE##*.}"

case "$EXT" in
  ts|tsx|js|jsx|json)
    if command -v prettier &> /dev/null; then
      prettier --write "$FILE"
      echo "✓ Formatted $FILE with Prettier"
    fi
    ;;
  py)
    if command -v black &> /dev/null; then
      black "$FILE"
      echo "✓ Formatted $FILE with Black"
    fi
    ;;
  go)
    if command -v gofmt &> /dev/null; then
      gofmt -w "$FILE"
      echo "✓ Formatted $FILE with gofmt"
    fi
    ;;
esac

exit 0
```

### Run Tests

Run tests when test files are modified:

```bash
#!/bin/bash
# test-runner.sh

set -e

FILE="$1"

# Only run for test files
if [[ "$FILE" != *".test."* ]] && [[ "$FILE" != *".spec."* ]]; then
  exit 0
fi

echo "Running tests for $FILE..."

# Run tests
npm test -- "$FILE"

echo "✓ Tests passed"
exit 0
```

### Lint Before Commit

Check code quality before committing:

```bash
#!/bin/bash
# pre-commit.sh

set -e

echo "Running pre-commit checks..."

# Run linter
echo "Linting..."
npm run lint

# Run type checker
echo "Type checking..."
npm run type-check

# Run tests
echo "Running tests..."
npm test

echo "✓ All checks passed"
exit 0
```

### Backup Files

Create backups before editing:

```bash
#!/bin/bash
# backup.sh

FILE="$1"
BACKUP_DIR=".backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Create backup
cp "$FILE" "$BACKUP_DIR/$(basename $FILE).$TIMESTAMP.bak"

echo "✓ Backed up $FILE"
exit 0
```

### Notify on Change

Send notification when files change:

```bash
#!/bin/bash
# notify.sh

FILE="$1"

# Send desktop notification (macOS)
if command -v osascript &> /dev/null; then
  osascript -e "display notification \"$FILE was modified\" with title \"Claude Code\""
fi

# Or use terminal-notifier
if command -v terminal-notifier &> /dev/null; then
  terminal-notifier -title "Claude Code" -message "$FILE was modified"
fi

exit 0
```

## Hook Parameters

Hooks receive different parameters depending on the event:

### File Operation Hooks
```bash
FILE="$1"          # Path to the file
OPERATION="$2"     # Operation type (read/write/edit)
```

### Git Hooks
```bash
COMMIT_MSG="$1"    # Commit message (for commit hooks)
BRANCH="$2"        # Current branch
REMOTE="$3"        # Remote name (for push hooks)
```

## Best Practices

### Writing Hooks

✅ **Do:**
- Use `set -e` to exit on errors
- Validate inputs
- Provide clear error messages
- Make hooks fast (they run frequently)
- Log what the hook is doing
- Test hooks independently
- Handle edge cases

❌ **Don't:**
- Make hooks too slow
- Forget error handling
- Assume files exist
- Make destructive changes without backups
- Ignore exit codes
- Create complex logic (use separate scripts)

### Performance

Hooks should be fast since they run frequently:

```bash
# Good: Quick checks
if command -v prettier &> /dev/null; then
  prettier --write "$FILE"
fi

# Bad: Slow operations
npm install  # Don't install packages in hooks
npm test     # Don't run full test suite (maybe just changed files)
```

### Error Handling

Always handle errors properly:

```bash
#!/bin/bash
set -e  # Exit on error

FILE="$1"

# Validate
if [ ! -f "$FILE" ]; then
  echo "Error: File not found"
  exit 1
fi

# Process
if ! prettier --write "$FILE" 2>&1; then
  echo "Warning: Prettier failed"
  # Don't exit - allow operation to continue
fi

exit 0
```

### Debugging Hooks

Add debugging output:

```bash
#!/bin/bash
set -x  # Print commands as they execute

FILE="$1"
echo "DEBUG: Processing file: $FILE"
echo "DEBUG: PWD: $(pwd)"

# ... rest of hook
```

## Hook Patterns

### Conditional Execution

Only run for specific file types:

```bash
#!/bin/bash

FILE="$1"
EXT="${FILE##*.}"

# Only process TypeScript files
if [ "$EXT" != "ts" ] && [ "$EXT" != "tsx" ]; then
  exit 0
fi

# Process TypeScript file
```

### Tool Detection

Check if tools are available:

```bash
#!/bin/bash

FILE="$1"

# Check for formatter
if ! command -v prettier &> /dev/null; then
  echo "Warning: prettier not found, skipping format"
  exit 0
fi

prettier --write "$FILE"
```

### Async Execution

Run hooks in background for slow operations:

```bash
#!/bin/bash

FILE="$1"

# Run in background
(
  # Slow operation
  npm run some-slow-task
) &

# Don't wait - exit immediately
exit 0
```

### Caching

Cache results to improve performance:

```bash
#!/bin/bash

FILE="$1"
CACHE_FILE=".hook-cache/$(echo $FILE | md5)"

# Check cache
if [ -f "$CACHE_FILE" ]; then
  FILE_HASH=$(md5sum "$FILE" | cut -d' ' -f1)
  CACHED_HASH=$(cat "$CACHE_FILE")

  if [ "$FILE_HASH" = "$CACHED_HASH" ]; then
    echo "Using cached result"
    exit 0
  fi
fi

# Process file
process_file "$FILE"

# Update cache
mkdir -p .hook-cache
md5sum "$FILE" | cut -d' ' -f1 > "$CACHE_FILE"
```

## Troubleshooting

### Hook Not Running

If hook doesn't execute:

1. Check file permissions: `ls -la .claude/hooks/`
2. Make executable: `chmod +x .claude/hooks/hook-name.sh`
3. Verify path in `.claude/settings.json`
4. Check for syntax errors: `bash -n .claude/hooks/hook-name.sh`
5. Test manually: `./.claude/hooks/hook-name.sh path/to/test/file`

### Hook Fails

If hook fails:

1. Check error message in Claude output
2. Run with debugging: `bash -x .claude/hooks/hook-name.sh file.txt`
3. Verify required tools are installed
4. Check file paths are correct
5. Review exit codes

### Hook Too Slow

If hooks make Claude slow:

1. Profile the hook: `time ./.claude/hooks/hook-name.sh file.txt`
2. Remove slow operations (full test suites, npm install)
3. Use caching for expensive operations
4. Run slow operations in background
5. Consider making hook optional

## Testing Hooks

Test hooks before enabling:

```bash
# Test with a sample file
./.claude/hooks/format-on-save.sh src/example.ts

# Test with different file types
./.claude/hooks/format-on-save.sh test.js
./.claude/hooks/format-on-save.sh test.py
./.claude/hooks/format-on-save.sh test.go

# Test error cases
./.claude/hooks/format-on-save.sh nonexistent.ts
```

## Further Reading

- [Settings Documentation](../settings.json) - Hook configuration
- [Customization Guide](../../docs/customization-guide.md) - Advanced patterns
- [Example Hooks](examples/) - More hook examples
