# Skills Directory

This directory contains custom skills that can be invoked in Claude Code.

## What are Skills?

Skills are reusable commands that extend Claude's capabilities. They can:
- Automate common workflows
- Enforce project standards
- Run custom scripts
- Integrate with external tools

## Directory Structure

```
skills/
├── README.md           # This file
└── examples/
    └── project-standards.md
```

## Using Skills

Skills are invoked with a slash command:

```
/skill-name
/skill-name arg1 arg2
```

Example:
```
/check-standards
/deploy staging
```

## Creating Skills

### Basic Skill

Create a markdown file in `.claude/skills/`:

```markdown
# My Custom Skill

---
name: my-skill
description: Brief description of what this skill does
version: 1.0.0
---

## What This Skill Does

Detailed description of the skill's functionality.

## Usage

\`/my-skill\` - Basic usage
\`/my-skill --option\` - With options

## Implementation

\`\`\`bash
#!/bin/bash
# Script implementation
echo "Running custom skill"
\`\`\`
```

### Skill with Arguments

```markdown
# Deploy Skill

---
name: deploy
description: Deploy application to specified environment
version: 1.0.0
arguments:
  - name: environment
    description: Target environment (staging/production)
    required: true
---

## What This Skill Does

Deploys the application to the specified environment.

## Usage

\`/deploy staging\` - Deploy to staging
\`/deploy production\` - Deploy to production

## Implementation

\`\`\`bash
#!/bin/bash
ENVIRONMENT=$1

# Validation
if [ "$ENVIRONMENT" != "staging" ] && [ "$ENVIRONMENT" != "production" ]; then
  echo "Error: Environment must be 'staging' or 'production'"
  exit 1
fi

# Deploy
echo "Deploying to $ENVIRONMENT..."
npm run build
npm run deploy:$ENVIRONMENT
echo "Deployment complete!"
\`\`\`
```

## Skill Frontmatter

Skills use YAML frontmatter for configuration:

```yaml
---
name: skill-name           # Required: Command name
description: Brief desc    # Required: What the skill does
version: 1.0.0            # Required: Semantic version
arguments:                 # Optional: Command arguments
  - name: arg1
    description: Argument description
    required: true
  - name: arg2
    description: Optional argument
    required: false
---
```

## Example Skills

### Example: Check Standards

```markdown
# Check Standards

---
name: check-standards
description: Verify code meets project standards
version: 1.0.0
---

## Usage

\`/check-standards\`

## What It Does

1. Runs linter
2. Runs type checker
3. Runs tests with coverage
4. Checks security vulnerabilities

## Implementation

\`\`\`bash
echo "Checking project standards..."
npm run lint && npm run type-check && npm test -- --coverage && npm audit
\`\`\`
```

### Example: Generate Component

```markdown
# Generate Component

---
name: generate-component
description: Generate a new React component with tests
version: 1.0.0
arguments:
  - name: name
    description: Component name (PascalCase)
    required: true
---

## Usage

\`/generate-component Button\`

## What It Does

Creates:
- Component file
- Test file
- Styles file
- Index file

## Implementation

\`\`\`bash
#!/bin/bash
NAME=$1

# Create directory
mkdir -p src/components/$NAME

# Create component file
cat > src/components/$NAME/$NAME.tsx <<EOF
import React from 'react';
import styles from './$NAME.module.css';

interface ${NAME}Props {
  children: React.ReactNode;
}

export const $NAME: React.FC<${NAME}Props> = ({ children }) => {
  return <div className={styles.container}>{children}</div>;
};
EOF

# Create test file
cat > src/components/$NAME/$NAME.test.tsx <<EOF
import { render, screen } from '@testing-library/react';
import { $NAME } from './$NAME';

describe('$NAME', () => {
  it('renders children', () => {
    render(<$NAME>Test</$ NAME>);
    expect(screen.getByText('Test')).toBeInTheDocument();
  });
});
EOF

# Create styles file
cat > src/components/$NAME/$NAME.module.css <<EOF
.container {
  /* Add styles */
}
EOF

# Create index file
cat > src/components/$NAME/index.ts <<EOF
export { $NAME } from './$NAME';
export type { ${NAME}Props } from './$NAME';
EOF

echo "Component $NAME created successfully!"
\`\`\`
```

### Example: Run Migration

```markdown
# Run Migration

---
name: migrate
description: Run database migrations
version: 1.0.0
arguments:
  - name: direction
    description: up or down
    required: false
---

## Usage

\`/migrate\` - Run pending migrations
\`/migrate down\` - Rollback last migration

## Implementation

\`\`\`bash
#!/bin/bash
DIRECTION=${1:-up}

if [ "$DIRECTION" = "up" ]; then
  npm run db:migrate
elif [ "$DIRECTION" = "down" ]; then
  npm run db:migrate:down
else
  echo "Invalid direction. Use 'up' or 'down'"
  exit 1
fi
\`\`\`
```

## Best Practices

### Skill Design

✅ **Do:**
- Give skills clear, descriptive names
- Include comprehensive usage examples
- Validate arguments
- Provide helpful error messages
- Make skills idempotent when possible
- Document what the skill does and why

❌ **Don't:**
- Create overly complex skills
- Use ambiguous names
- Skip error handling
- Forget to test skills
- Make destructive actions without confirmation

### Skill Organization

- **Simple Skills:** Single file in `.claude/skills/`
- **Complex Skills:** Separate directory with supporting files
- **Examples:** Keep in `examples/` subdirectory
- **Documentation:** Always include usage and examples

### Testing Skills

Test skills before using:

```bash
# Test the skill script directly
bash .claude/skills/my-skill.sh arg1 arg2

# Test in Claude
claude
> /my-skill arg1 arg2
```

## Common Skill Patterns

### Validation Pattern

```bash
#!/bin/bash
set -e

# Validate arguments
if [ -z "$1" ]; then
  echo "Error: Missing required argument"
  exit 1
fi

# Validate environment
if [ ! -f "package.json" ]; then
  echo "Error: Must run in project root"
  exit 1
fi

# Run skill
echo "Running skill..."
```

### Confirmation Pattern

```bash
#!/bin/bash
set -e

# Confirmation for destructive actions
read -p "Are you sure? (y/N): " confirm
if [[ ! $confirm =~ ^[Yy]$ ]]; then
  echo "Cancelled"
  exit 0
fi

# Run destructive action
echo "Proceeding..."
```

### Progress Pattern

```bash
#!/bin/bash
set -e

echo "Step 1/3: Building..."
npm run build

echo "Step 2/3: Testing..."
npm test

echo "Step 3/3: Deploying..."
npm run deploy

echo "✓ Complete!"
```

## Troubleshooting

### Skill Not Found

If `/skill-name` doesn't work:

1. Check file is in `.claude/skills/`
2. Verify YAML frontmatter is valid
3. Ensure skill name in frontmatter matches
4. Restart Claude Code

### Skill Fails to Execute

If skill fails:

1. Test script directly: `bash .claude/skills/skill-name.sh`
2. Check file permissions: `chmod +x .claude/skills/skill-name.sh`
3. Verify dependencies are installed
4. Check error messages in output
5. Add `set -x` to script for debugging

## Further Reading

- [Customization Guide](../../docs/customization-guide.md) - Advanced customization
- [Example Skills](examples/) - More skill examples
- [Hooks Documentation](../hooks/README.md) - Related automation
