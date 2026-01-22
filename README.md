# Claude Code Project Template

<div align="center">

[![Use this template](https://img.shields.io/badge/Use%20this%20template-2ea44f?style=for-the-badge&logo=github)](https://github.com/chrismalone617/claude-code-template/generate)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/chrismalone617/claude-code-template?style=flat-square)](https://github.com/chrismalone617/claude-code-template/stargazers)

**A comprehensive, reusable template for configuring [Claude Code](https://github.com/anthropics/claude-code) with personal preferences, project requirements, MCP server examples, and automation scripts.**

[Quick Start](#quick-start) • [Features](#features) • [Documentation](#documentation) • [Examples](#examples)

</div>

---

## Features

### 📋 Personal Preferences
Customize how Claude communicates and codes with you:
- **Communication Style** - Tone, verbosity, interaction patterns
- **Coding Style** - Language preferences, formatting, patterns
- **Personal Context** - Your background, skills, work environment

### 🎯 Project Requirements
Standardize project-wide practices:
- **Testing Standards** - Coverage requirements, testing patterns
- **Documentation** - Code comments, API docs, changelogs
- **Security** - Authentication, validation, security checklist
- **Code Quality** - Review standards, error handling, logging

### 🔌 MCP Server Examples
Pre-configured examples for common integrations:
- GitHub, PostgreSQL, Filesystem access
- Sequential thinking, Web search, Browser automation
- Slack, Memory, and more
- Custom server templates

### ⚙️ Configuration Templates
Ready-to-use configurations:
- Project memory template (CLAUDE.md)
- Settings with hooks and permissions
- Example skills and hooks
- Path-specific rules

### 📚 Comprehensive Documentation
Guides for every aspect:
- Quick start and setup instructions
- MCP servers reference
- Customization guide
- Maintenance and sync strategies

## Quick Start

### 1. Clone the Template

```bash
# Clone this repository for a new project
git clone https://github.com/chrismalone617/claude-code-template my-new-project
cd my-new-project

# Remove git history (optional - if you want a fresh start)
rm -rf .git
git init
```

### 2. Run Setup Script

```bash
chmod +x setup.sh
./setup.sh
```

The setup script will:
- Create necessary directories
- Copy example files
- Guide you through initial configuration
- Help set up environment variables

### 3. Customize for Your Project

1. **Edit `.claude/CLAUDE.md`** - Update project overview, commands, architecture
2. **Configure MCP Servers** - Edit `.mcp.json` with servers you need
3. **Set Environment Variables** - Create `.env` file with required secrets
4. **Customize Rules** - Adjust `.claude/rules/` to match your preferences
5. **Update Project Requirements** - Modify `.claude/rules/project/` for your standards

### 4. Start Using Claude Code

```bash
claude
```

Claude will now use your customized configuration!

## Features

### Modular Rules System
```
.claude/rules/
  ├── personal/          # Your personal preferences (can be symlinked)
  ├── project/           # Project-specific requirements (shared)
  └── examples/          # Example rules to learn from
```

### Flexible MCP Configuration
- `.mcp.json` - Active servers (version controlled)
- `.mcp.example.json` - Comprehensive examples and documentation
- `.mcp.local.json` - Local overrides (gitignored)

### Example Skills
Pre-built skills for common tasks:
- `/check-standards` - Verify code follows project standards
- Add your own custom skills

### Example Hooks
Automation via hooks:
- Auto-format code after edits
- Run tests automatically
- Custom validation

## Usage Across Multiple Projects

### Option 1: Clone Per Project
Each project gets its own copy of the template, customized for that project.

```bash
# For each new project
git clone https://github.com/chrismalone617/claude-code-template my-project
cd my-project
./setup.sh
# Customize for this project
```

### Option 2: Symlink Personal Rules
Share personal preferences across all projects:

```bash
# Create a personal rules repo
mkdir -p ~/.claude-personal-rules
# Symlink personal rules in each project
ln -s ~/.claude-personal-rules .claude/rules/personal
```

### Option 3: Template Repository
Use as a GitHub template repository:
1. Click "Use this template" on GitHub
2. Clone your new repository
3. Customize for your project

## Directory Structure

```
claude-code-template/
├── .claude/
│   ├── CLAUDE.md                    # Project memory template
│   ├── settings.json                # Shared settings
│   ├── settings.local.json.example  # Personal settings example
│   ├── rules/
│   │   ├── personal/                # Personal preferences
│   │   ├── project/                 # Project requirements
│   │   └── examples/                # Example rules
│   ├── skills/
│   │   └── examples/                # Example skills
│   └── hooks/
│       └── examples/                # Example hooks
├── docs/
│   ├── mcp-servers-guide.md         # MCP reference
│   ├── customization-guide.md       # How to customize
│   └── maintenance-guide.md         # Keeping updated
├── .mcp.json                        # Active MCP servers
├── .mcp.example.json                # MCP examples
├── .gitignore                       # Excludes sensitive files
├── setup.sh                         # Setup automation
├── README.md                        # This file
└── SETUP.md                         # Detailed setup guide
```

## Documentation

- **[SETUP.md](SETUP.md)** - Detailed setup instructions
- **[MCP Servers Guide](docs/mcp-servers-guide.md)** - Complete MCP reference
- **[Customization Guide](docs/customization-guide.md)** - How to customize everything
- **[Maintenance Guide](docs/maintenance-guide.md)** - Keeping your config updated

## Environment Variables

Common environment variables you'll need:

```bash
# GitHub integration
GITHUB_TOKEN=ghp_...

# Database (if using)
DATABASE_URL=postgresql://user:pass@localhost:5432/db

# Web search (if using)
BRAVE_API_KEY=...

# Custom services
API_KEY=...
```

See **[SETUP.md](SETUP.md)** for complete environment variable reference.

## Examples

### Personal Communication Style
```markdown
# .claude/rules/personal/communication-style.md
- Keep responses concise and technical
- Use examples for complex concepts
- Always explain the "why" behind decisions
- Ask clarifying questions when requirements are ambiguous
```

### Project Testing Standards
```markdown
# .claude/rules/project/testing.md
- Minimum 85% code coverage
- Unit tests for all business logic
- Integration tests for APIs
- E2E tests for critical user flows
```

### Path-Specific Rules
```markdown
# .claude/rules/examples/frontend-example.md
---
paths:
  - "src/components/**"
  - "src/pages/**"
---
- Use functional components with hooks
- All components must have TypeScript types
- Include accessibility attributes
```

## Tips

### Getting Started
- Start simple - don't over-configure initially
- Gradually add rules as you discover preferences
- Use examples as starting points
- Test configurations with simple requests

### Best Practices
- Keep personal rules separate from project rules
- Document why rules exist, not just what they are
- Review and update rules periodically
- Share project rules with your team
- Keep sensitive data in environment variables

### Common Patterns
- Symlink personal rules for consistency across projects
- Use `.mcp.local.json` for machine-specific MCP servers
- Keep `.claude/CLAUDE.md` updated as project evolves
- Use path-specific rules for different parts of codebase

## Contributing

Found a bug or have a suggestion? Please open an issue or submit a pull request!

Ideas for contributions:
- Additional example rules for different tech stacks
- More example skills
- Additional hook examples
- Improved documentation
- Setup script enhancements

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Resources

- **[Claude Code Documentation](https://docs.claude.ai/claude-code)** - Official docs
- **[Model Context Protocol](https://modelcontextprotocol.io)** - MCP specification
- **[Claude Code GitHub](https://github.com/anthropics/claude-code)** - Source and issues
- **[MCP Servers](https://github.com/modelcontextprotocol/servers)** - Official MCP servers
- **[Awesome MCP Servers](https://github.com/punkpeye/awesome-mcp-servers)** - Community servers

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for detailed version history and release notes.

### Version 1.0.0 (2024-01-22)
- Initial template release with complete structure
- Personal preference templates (communication, coding, context)
- Project requirements templates (testing, docs, security, quality)
- MCP server examples and comprehensive configuration
- Example rules, skills, and hooks
- Interactive setup script with validation
- Comprehensive documentation (8,325+ lines)

---

**Need Help?** See [SETUP.md](SETUP.md) for detailed setup instructions or [open an issue](https://github.com/chrismalone617/claude-code-template/issues).
