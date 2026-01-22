# Customization Guide

Learn how to customize every aspect of your Claude Code configuration.

## Table of Contents

- [Personal Preferences](#personal-preferences)
- [Project Requirements](#project-requirements)
- [Project Memory (CLAUDE.md)](#project-memory-claudemd)
- [Path-Specific Rules](#path-specific-rules)
- [MCP Servers](#mcp-servers)
- [Settings and Hooks](#settings-and-hooks)
- [Skills](#skills)
- [Advanced Patterns](#advanced-patterns)

## Personal Preferences

Personal preferences define how Claude communicates and codes with you. These are stored in `.claude/rules/personal/`.

### Communication Style

Edit `.claude/rules/personal/communication-style.md`:

```markdown
## My Preferences
- **Tone**: Professional but friendly
- **Verbosity**: Concise responses, detailed only when asked
- **Explanations**: Always explain "why" behind decisions
- **Questions**: Ask for clarification when ambiguous
- **Examples**: Use TypeScript for all code examples
```

**Tips:**
- Be specific about what you want differently
- Include examples of good/bad communication
- Update as you discover preferences
- Consider creating different profiles for different contexts

### Coding Style

Edit `.claude/rules/personal/coding-style.md`:

```markdown
## My Preferences

### TypeScript
- Strict mode always enabled
- Explicit return types for functions
- Interfaces for object shapes
- No `any` types - use `unknown` and narrow

### React
- Functional components with hooks only
- Props destructured in parameter list
- Custom hooks prefixed with `use`
- Prop types defined as interfaces

### Testing
- Jest for unit tests
- React Testing Library for component tests
- Minimum 85% coverage for new code
- Test behavior, not implementation

### Formatting
- 2-space indentation
- Single quotes for strings
- Template literals for interpolation
- Trailing commas in multiline
```

**Tips:**
- Link to your ESLint/Prettier config
- Specify auto-formatting tools in use
- Note company/team style guides to follow
- Focus on preferences that matter most

### Personal Context

Edit `.claude/rules/personal/context.md`:

```markdown
## My Context

### Experience
- Senior full-stack engineer, 8 years experience
- Expert in TypeScript, React, Node.js, PostgreSQL
- Learning Rust and systems programming
- Strong in backend, improving frontend skills

### Environment
- macOS 14 with Apple Silicon
- VS Code with Vim extension
- zsh with oh-my-zsh
- iTerm2 terminal

### Work Style
- Pragmatic over perfect
- Ship fast, iterate quickly
- Test critical paths thoroughly
- Document for clarity, not completeness

### Current Focus
- Building SaaS products
- Microservices architecture
- Performance optimization
- Developer experience
```

**Tips:**
- Be honest about experience level
- Mention specific challenges you face
- Note technologies you're learning
- Include relevant work context

## Project Requirements

Project requirements define standards that apply project-wide. These are stored in `.claude/rules/project/`.

### Testing Standards

Edit `.claude/rules/project/testing.md`:

```markdown
## This Project Requirements

### Frameworks
- Jest for unit and integration tests
- Playwright for E2E tests
- React Testing Library for components

### Coverage
- Minimum 85% for new code
- 100% for critical business logic
- Exceptions: UI-only components, generated code

### Required Tests
- Unit tests for all services and utilities
- Integration tests for all API endpoints
- E2E tests for critical user flows
- Component tests for complex UI

### Naming
- `*.test.ts` for unit tests
- `*.integration.test.ts` for integration
- `*.e2e.test.ts` for end-to-end

### Pre-Commit
- Run related tests before committing
- Full suite runs in CI
```

**Tips:**
- Align with team practices
- Be specific about coverage requirements
- Define what "critical" means for your project
- Include examples of good tests

### Documentation Standards

Edit `.claude/rules/project/documentation.md`:

```markdown
## This Project Requirements

### Code Comments
- JSDoc for all public APIs
- Inline comments only for complex logic
- Explain "why", not "what"
- TODO comments include ticket number

### Project Documentation
- README with setup and quick start
- CHANGELOG with all user-facing changes
- API documentation in OpenAPI format
- Architecture decisions in docs/adr/

### Commit Messages
- Follow Conventional Commits
- Format: `type(scope): description`
- Include ticket number if applicable

### PR Descriptions
Required sections:
- What: Brief description
- Why: Motivation
- How: Technical approach
- Testing: How it was tested
```

### Security Standards

Edit `.claude/rules/project/security.md`:

```markdown
## This Project Requirements

### Authentication
- JWT tokens with 1-hour expiry
- Refresh tokens with 7-day expiry
- MFA required for admin accounts

### Password Security
- bcrypt with cost factor 12
- Minimum 12 characters
- Complexity requirements enforced

### Input Validation
- Zod schemas for all API inputs
- Sanitize HTML output
- Parameterized queries only (Prisma)

### Security Headers
- Helmet.js for Express security headers
- CORS restricted to known origins
- CSP with strict policy

### Dependencies
- npm audit on every CI build
- Fail on moderate+ vulnerabilities
- Review before adding new dependencies
```

### Code Quality Standards

Edit `.claude/rules/project/quality.md`:

```markdown
## This Project Requirements

### Linting
- ESLint with `@typescript-eslint/recommended`
- Prettier for auto-formatting
- Pre-commit hooks enforce both

### Complexity
- Max cyclomatic complexity: 10
- Max function length: 50 lines
- Max file length: 400 lines

### Code Review
- Minimum 1 reviewer required
- 2 for critical changes
- All CI checks must pass
- No unresolved comments

### Logging
- Winston for structured logging
- Log levels: error, warn, info, debug
- Never log passwords or tokens
- Include context: userId, requestId
```

## Project Memory (CLAUDE.md)

The `.claude/CLAUDE.md` file is Claude's main source of project context.

### Essential Sections

```markdown
# Project Memory

## Project Overview
Brief description of what this project does and its purpose.

## Tech Stack
- Frontend: React 18 with TypeScript
- Backend: Node.js with Express
- Database: PostgreSQL with Prisma ORM
- Infrastructure: Docker, AWS ECS

## Quick Commands
\`\`\`bash
npm run dev        # Start development server
npm test          # Run tests
npm run build     # Build for production
npm run db:migrate # Run database migrations
\`\`\`

## Architecture
High-level overview of how the system works.

## Important Locations
- `src/api/` - API routes and controllers
- `src/services/` - Business logic
- `src/db/` - Database models and migrations

## Environment Variables
\`\`\`bash
DATABASE_URL=postgresql://...
JWT_SECRET=...
API_KEY=...
\`\`\`

## Common Tasks
### Adding a New API Endpoint
1. Create route in `src/api/routes/`
2. Add controller in `src/api/controllers/`
3. Add service logic in `src/services/`
4. Add tests
5. Update API documentation
```

### Tips for CLAUDE.md

- **Be Specific:** Focus on what's unique to your project
- **Keep Updated:** Update when architecture changes
- **Link to Details:** Reference other docs rather than duplicating
- **Include Examples:** Show actual commands and file paths
- **Prioritize:** Most important info at the top

### What to Include

✅ **Do Include:**
- Project purpose and key features
- Tech stack and architecture decisions
- Common commands and workflows
- File organization and key locations
- Environment variables needed
- Common tasks and how-tos

❌ **Don't Include:**
- Generic information (how React works)
- Information that changes frequently (specific line numbers)
- Duplicate of external documentation
- Personal preferences (use rules/ instead)

## Path-Specific Rules

Rules can be scoped to specific file paths using YAML frontmatter.

### Basic Path Rules

Create `.claude/rules/project/frontend-rules.md`:

```markdown
---
name: frontend-rules
paths:
  - "src/components/**"
  - "src/pages/**"
priority: 10
---

# Frontend-Specific Rules

These rules apply only to frontend code.

## Component Structure
- Functional components with hooks only
- Props interface named `{Component}Props`
- One component per file
```

### Multiple Path Scopes

```markdown
---
name: test-rules
paths:
  - "**/*.test.ts"
  - "**/*.spec.ts"
  - "**/__tests__/**"
priority: 20
---

# Test File Rules
- Use describe/it structure
- Test names describe behavior
- Each test is independent
```

### Priority System

Higher priority rules override lower priority:

```markdown
---
priority: 10  # Lower priority (more general)
---

---
priority: 20  # Higher priority (more specific)
---
```

## MCP Servers

Customize MCP servers in `.mcp.json`.

### Adding a Server

```json
{
  "mcpServers": {
    "my-new-server": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-example"],
      "env": {
        "API_KEY": "${MY_API_KEY}"
      }
    }
  }
}
```

### Machine-Specific Servers

Create `.mcp.local.json` (gitignored) for local overrides:

```json
{
  "mcpServers": {
    "local-db": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://localhost:5432/dev"
      ]
    }
  }
}
```

### Conditional Servers

Use environment variables to enable/disable:

```json
{
  "mcpServers": {
    "production-db": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "${PROD_DB_URL}"],
      "_disabled": "${NODE_ENV !== 'production'}"
    }
  }
}
```

## Settings and Hooks

Configure Claude Code behavior in `.claude/settings.json`.

### Permissions

```json
{
  "permissions": {
    "allowedCommands": {
      "bash": ["npm", "git", "docker", "pytest"]
    },
    "blockedPaths": [
      "node_modules/**",
      ".env",
      "secrets/**"
    ]
  }
}
```

### Hooks

```json
{
  "hooks": {
    "beforeEdit": ".claude/hooks/backup.sh",
    "afterEdit": ".claude/hooks/format-on-save.sh",
    "beforeCommit": ".claude/hooks/pre-commit.sh"
  }
}
```

### Hook Script Example

Create `.claude/hooks/format-on-save.sh`:

```bash
#!/bin/bash
FILE="$1"

# Format with Prettier
if [[ "$FILE" == *.ts ]] || [[ "$FILE" == *.tsx ]]; then
  prettier --write "$FILE"
  echo "Formatted $FILE"
fi
```

Make executable:
```bash
chmod +x .claude/hooks/format-on-save.sh
```

## Skills

Create custom skills in `.claude/skills/`.

### Basic Skill

Create `.claude/skills/deploy.md`:

```markdown
---
name: deploy
description: Deploy to staging or production
version: 1.0.0
---

# Deploy Skill

## Usage
\`/deploy staging\` - Deploy to staging
\`/deploy production\` - Deploy to production

## What it does
1. Runs tests
2. Builds application
3. Pushes to specified environment
4. Verifies deployment

## Implementation
\`\`\`bash
npm test && npm run build && npm run deploy:$1
\`\`\`
```

### Skill with Arguments

```markdown
---
name: analyze
description: Analyze code for issues
version: 1.0.0
arguments:
  - name: path
    description: Path to analyze
    required: true
  - name: deep
    description: Deep analysis mode
    required: false
---

# Code Analysis Skill

Analyzes code for potential issues.
```

## Advanced Patterns

### Shared Personal Rules Across Projects

```bash
# Create personal rules repository
mkdir -p ~/.claude-personal-rules
cd ~/.claude-personal-rules
git init

# Move personal rules
mv communication-style.md ~/.claude-personal-rules/
mv coding-style.md ~/.claude-personal-rules/
mv context.md ~/.claude-personal-rules/

# In each project
cd ~/project
rm -rf .claude/rules/personal
ln -s ~/.claude-personal-rules .claude/rules/personal

# Commit symlink
git add .claude/rules/personal
git commit -m "Link to shared personal rules"
```

### Team-Specific Rules Repository

```bash
# Create team rules repository
git clone git@github.com:team/claude-rules.git

# In each project
ln -s ../claude-rules/project/* .claude/rules/project/
```

### Dynamic Configuration

Use environment variables in rules:

```markdown
---
name: api-rules
paths:
  - "src/api/**"
---

# API Rules

## Base URL
Use \`${API_BASE_URL}\` for all API calls.

## Authentication
Token stored in \`${AUTH_TOKEN}\` environment variable.
```

### Conditional Rules

```markdown
---
name: production-rules
paths:
  - "src/**"
enabled: "${NODE_ENV === 'production'}"
---

# Production-Only Rules

- No console.log statements
- All errors logged to Sentry
- Performance monitoring enabled
```

## Tips and Best Practices

### Start Simple
- Begin with basic configuration
- Add rules gradually as you discover preferences
- Don't over-configure initially

### Be Specific
- Specific rules are more useful than vague ones
- Include examples of what you want
- Show both good and bad examples

### Keep Updated
- Review rules periodically
- Remove obsolete rules
- Update as project evolves

### Document Why
- Explain reasoning behind rules
- Note exceptions and edge cases
- Link to relevant documentation

### Test Changes
- Test rule changes with simple requests
- Verify Claude follows new rules
- Refine based on results

### Share Wisely
- Share project rules with team
- Keep personal rules personal (or use symlinks)
- Document any custom configurations

---

**Next:** [Maintenance Guide](maintenance-guide.md) - Learn how to keep your configuration updated.
