# Rules Directory

This directory contains rules that guide Claude's behavior when working on this project.

## Directory Structure

```
rules/
├── README.md           # This file
├── personal/           # Personal preferences
│   ├── communication-style.md
│   ├── coding-style.md
│   └── context.md
├── project/            # Project requirements
│   ├── testing.md
│   ├── documentation.md
│   ├── security.md
│   └── quality.md
└── examples/           # Example rules
    ├── frontend-example.md
    ├── backend-example.md
    └── path-specific-example.md
```

## Rule Types

### Personal Rules (`personal/`)

Personal preferences that define how Claude communicates and codes with you.

**Files:**
- `communication-style.md` - How Claude should communicate (tone, verbosity, style)
- `coding-style.md` - Your coding preferences (formatting, patterns, conventions)
- `context.md` - Your background, skills, and work environment

**Usage:** These are personal to you and can be:
- Committed to the project (solo projects)
- Excluded via `.gitignore` (team projects)
- Symlinked from a personal rules repository (consistency across projects)

### Project Rules (`project/`)

Project-wide requirements that apply to all contributors.

**Files:**
- `testing.md` - Testing standards and requirements
- `documentation.md` - Documentation requirements
- `security.md` - Security standards and checklist
- `quality.md` - Code quality and review standards

**Usage:** These should be committed to the project and shared with the team.

### Example Rules (`examples/`)

Examples demonstrating different rule patterns.

**Files:**
- `frontend-example.md` - Frontend-specific rules
- `backend-example.md` - Backend-specific rules
- `path-specific-example.md` - Path-scoped rules with YAML frontmatter

**Usage:** Reference examples when creating your own rules.

## Creating Rules

### Basic Rule

Create a markdown file in the appropriate directory:

```markdown
# My Custom Rules

## Coding Standards
- Always use TypeScript
- Prefer functional programming
- Write comprehensive tests

## Communication
- Keep responses concise
- Use code examples
```

### Path-Specific Rule

Use YAML frontmatter to scope rules to specific paths:

```markdown
---
name: api-rules
paths:
  - "src/api/**"
  - "src/controllers/**"
priority: 10
---

# API Rules

These rules apply only to API code.

## REST Conventions
- Use plural nouns for resources
- Return appropriate HTTP status codes
```

## Rule Priority

Rules have priority levels (default: 0):
- **0-9:** Low priority (general rules)
- **10-19:** Medium priority (category-specific)
- **20+:** High priority (path-specific, overrides)

Higher priority rules override lower priority rules.

## Best Practices

### Writing Good Rules

✅ **Do:**
- Be specific and actionable
- Include examples
- Explain the "why" behind rules
- Update as you discover preferences
- Organize by category

❌ **Don't:**
- Write vague rules ("write good code")
- Duplicate information
- Create too many rules at once
- Forget to update outdated rules

### Organization Tips

1. **Start Simple:** Begin with basic preferences, add complexity gradually
2. **Be Specific:** "Use 2-space indentation" not "format code nicely"
3. **Use Examples:** Show good and bad examples
4. **Keep Current:** Remove obsolete rules, update as needed
5. **Test Rules:** Verify Claude follows your rules with test requests

### Personal vs Project Rules

**Personal Rules** should contain:
- Communication preferences
- Code style preferences
- Your background and context
- Personal workflow preferences

**Project Rules** should contain:
- Testing requirements
- Documentation standards
- Security requirements
- Code quality standards
- Team conventions

## Troubleshooting

### Rules Not Applied

If Claude doesn't seem to follow your rules:

1. **Check File Location:** Rules must be in `.claude/rules/`
2. **Check File Format:** Must be markdown (`.md`)
3. **Check YAML Syntax:** For path-specific rules, verify YAML frontmatter
4. **Check Priority:** Higher priority rules override lower
5. **Restart Claude:** Try restarting Claude Code
6. **Test Simple Rule:** Create a simple test rule to isolate the issue

### Conflicting Rules

If rules conflict:
- Higher priority rules win
- More specific rules override general rules
- Later rules in same file override earlier rules
- Consider consolidating or clarifying rules

## Examples

### Example: Communication Style

```markdown
# Communication Style

## My Preferences
- Concise, technical responses
- Always explain security implications
- Ask questions when unclear
- No emojis in technical discussions
```

### Example: Path-Specific Testing Rules

```markdown
---
name: test-rules
paths:
  - "**/*.test.ts"
  - "**/*.spec.ts"
priority: 15
---

# Test Rules

- Use describe/it structure
- Test names describe behavior
- Include setup and teardown
```

## Further Reading

- [Customization Guide](../../docs/customization-guide.md) - Comprehensive customization guide
- [CLAUDE.md](../CLAUDE.md) - Main project memory
- [Example Rules](examples/) - More examples to learn from
