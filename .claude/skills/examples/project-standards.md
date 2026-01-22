# Project Standards Skill

<!--
This is an example skill that enforces project standards.
Skills are reusable commands that can be invoked with /skill-name
-->

---
name: check-standards
description: Check if code follows project standards
version: 1.0.0
---

# Project Standards Checker

This skill checks if the current code follows project standards and best practices.

## What This Skill Does

When invoked, this skill will:
1. Check code formatting (linting, prettier)
2. Verify test coverage meets requirements
3. Check for security vulnerabilities in dependencies
4. Verify documentation is up-to-date
5. Check for TODO/FIXME comments
6. Verify commit message format

## Usage

Invoke this skill by typing:
```
/check-standards
```

Or with specific checks:
```
/check-standards --quick    # Run quick checks only
/check-standards --full     # Run all checks including slow ones
```

## Standards Checked

### Code Quality
- [ ] All files pass linting (ESLint/Prettier)
- [ ] No TypeScript errors (`tsc --noEmit`)
- [ ] Test coverage above 80%
- [ ] No console.log statements in production code
- [ ] All functions have JSDoc comments (for public APIs)

### Security
- [ ] No high/critical vulnerabilities (`npm audit`)
- [ ] No secrets in code (API keys, passwords)
- [ ] Dependencies are up-to-date

### Documentation
- [ ] README.md is up-to-date
- [ ] CHANGELOG.md includes recent changes
- [ ] All environment variables documented
- [ ] API documentation matches implementation

### Git Standards
- [ ] Recent commits follow conventional commit format
- [ ] No large files committed (>1MB)
- [ ] .gitignore properly configured

### Code Organization
- [ ] No files over 500 lines
- [ ] No functions over 50 lines
- [ ] Consistent file naming
- [ ] Proper directory structure

## Implementation

```bash
#!/bin/bash
# This would be implemented as a script or skill handler

echo "🔍 Checking Project Standards..."
echo ""

# 1. Check linting
echo "📝 Checking code formatting..."
npm run lint || echo "⚠️  Linting issues found"

# 2. Check TypeScript
echo "🔍 Checking TypeScript..."
npm run type-check || echo "⚠️  Type errors found"

# 3. Check tests
echo "🧪 Running tests..."
npm test -- --coverage
COVERAGE=$(cat coverage/coverage-summary.json | jq '.total.lines.pct')
if (( $(echo "$COVERAGE < 80" | bc -l) )); then
  echo "⚠️  Coverage below 80%: $COVERAGE%"
fi

# 4. Check security
echo "🔒 Checking security..."
npm audit --audit-level=moderate || echo "⚠️  Security vulnerabilities found"

# 5. Check for TODOs
echo "📋 Checking for TODOs..."
TODO_COUNT=$(grep -r "TODO\|FIXME" src/ | wc -l)
echo "Found $TODO_COUNT TODO/FIXME comments"

# 6. Check commit messages
echo "💬 Checking recent commits..."
git log --oneline -5 | grep -E "^[a-f0-9]+ (feat|fix|docs|style|refactor|test|chore)" || echo "⚠️  Some commits don't follow conventional format"

echo ""
echo "✅ Standards check complete!"
```

## Configuration

You can customize the standards in `.claude/rules/project/quality.md`.

## When to Use

Run this skill:
- Before creating a pull request
- After making significant changes
- When onboarding to verify setup
- During code review
- Before releases

## Tips

- Fix issues incrementally rather than all at once
- Some checks may be slow on large codebases
- Configure git hooks to run checks automatically
- Adjust standards in project rules as needed
