# Setup Guide

This guide walks you through setting up the Claude Code project template step by step.

## Prerequisites

### Required
- **Claude Code** installed and configured
  ```bash
  # Install Claude Code (if not already installed)
  npm install -g @anthropic/claude-code
  ```
- **Git** for cloning the template
- **Node.js** 16+ (for MCP servers via npx)

### Optional
- **GitHub Personal Access Token** (for GitHub MCP server)
- **Database** (if using database MCP servers)
- **API Keys** (for various MCP services)

## Installation Steps

### 1. Clone the Template

Choose one of these methods:

#### Method A: Clone for a New Project
```bash
# Clone the template
git clone https://github.com/chrismalone617/claude-code-template my-project
cd my-project

# Optional: Remove git history for fresh start
rm -rf .git
git init
```

#### Method B: Use GitHub Template
1. Go to the template repository on GitHub
2. Click "Use this template"
3. Create your new repository
4. Clone your new repository

#### Method C: Download ZIP
1. Download the template as ZIP
2. Extract to your project directory
3. Initialize git if needed: `git init`

### 2. Run Setup Script

```bash
# Make setup script executable
chmod +x setup.sh

# Run the setup script
./setup.sh
```

The setup script will guide you through:
- Verifying directory structure
- Copying example files
- Setting up environment variables
- Configuring MCP servers
- Customizing personal preferences

### 3. Configure Environment Variables

Create a `.env` file in your project root:

```bash
# Copy the example
cp .env.example .env

# Edit with your values
nano .env  # or use your preferred editor
```

#### Required Environment Variables

```bash
# GitHub Integration (if using GitHub MCP server)
GITHUB_TOKEN=ghp_your_token_here
# Create at: https://github.com/settings/tokens
# Required scopes: repo, read:org

# Database (if using database MCP servers)
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# Node Environment
NODE_ENV=development
```

#### Optional Environment Variables

```bash
# Brave Search (if using web search)
BRAVE_API_KEY=your_brave_api_key
# Get from: https://brave.com/search/api/

# Slack Integration (if using Slack MCP server)
SLACK_BOT_TOKEN=xoxb-your-token
SLACK_TEAM_ID=T1234567890
# Setup at: https://api.slack.com/apps

# Google Drive (if using Google Drive MCP server)
GOOGLE_CLIENT_ID=your_client_id
GOOGLE_CLIENT_SECRET=your_client_secret
GOOGLE_REFRESH_TOKEN=your_refresh_token

# AWS (if using AWS services)
AWS_ACCESS_KEY_ID=your_key_id
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_REGION=us-east-1

# Custom API Keys
API_KEY=your_api_key
CUSTOM_SERVICE_URL=https://api.example.com
```

### 4. Configure MCP Servers

Edit `.mcp.json` to enable the MCP servers you need:

```bash
# Edit the MCP configuration
nano .mcp.json
```

#### Example: Enable GitHub and Filesystem

```json
{
  "mcpServers": {
    "github": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "filesystem": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "${PWD}"],
      "_note": "Restricts filesystem access to current directory"
    }
  }
}
```

**Reference:** See `.mcp.example.json` for comprehensive examples of all available servers.

### 5. Customize Personal Preferences

Edit the personal preference files to match your style:

#### Communication Style
```bash
nano .claude/rules/personal/communication-style.md
```

Example customization:
```markdown
## My Preferences
- Keep responses concise and technical
- Use TypeScript for all examples
- Always explain security implications
- Ask questions when requirements are unclear
- No emojis in technical discussions
```

#### Coding Style
```bash
nano .claude/rules/personal/coding-style.md
```

Example customization:
```markdown
## My Preferences
- TypeScript strict mode always
- 2-space indentation
- Single quotes for strings
- Functional components with hooks in React
- Extensive JSDoc for public APIs only
```

#### Personal Context
```bash
nano .claude/rules/personal/context.md
```

Example customization:
```markdown
## My Context
- Senior full-stack engineer with 8 years experience
- Expert in TypeScript, React, Node.js, PostgreSQL
- Currently learning Rust
- macOS with VS Code, zsh, iTerm2
- Prefer pragmatic solutions over perfect code
```

### 6. Customize Project Requirements

Edit project-wide requirements:

```bash
# Testing standards
nano .claude/rules/project/testing.md

# Documentation requirements
nano .claude/rules/project/documentation.md

# Security requirements
nano .claude/rules/project/security.md

# Code quality standards
nano .claude/rules/project/quality.md
```

### 7. Update Project Memory (CLAUDE.md)

Customize the main project memory file for your specific project:

```bash
nano .claude/CLAUDE.md
```

Update these sections:
- **Project Overview** - What your project does
- **Quick Commands** - Common commands for your project
- **Architecture Overview** - Your tech stack and structure
- **Important Locations** - Key files and directories
- **Environment Variables** - Required variables for your project

### 8. Configure Settings (Optional)

#### Shared Settings
Edit `.claude/settings.json` for team-wide settings:

```json
{
  "permissions": {
    "allowedCommands": {
      "bash": [
        "npm",
        "git",
        "docker"
      ]
    }
  },
  "hooks": {
    "afterEdit": ".claude/hooks/format-on-save.sh"
  }
}
```

#### Local Settings
Create `.claude/settings.local.json` for personal overrides:

```bash
cp .claude/settings.local.json.example .claude/settings.local.json
nano .claude/settings.local.json
```

### 9. Verify Installation

Test that everything is working:

```bash
# Start Claude Code
claude

# In Claude, try:
# "What is this project?"
# "Show me the available MCP servers"
# "What are the testing requirements?"
```

Claude should:
- Read and understand your project context from CLAUDE.md
- Apply your personal preferences from rules
- Have access to configured MCP servers
- Follow project requirements

## Post-Setup Tasks

### Initialize Git (if starting fresh)

```bash
git init
git add .
git commit -m "Initial commit with Claude Code template"
```

### Create .gitignore Entries

Verify `.gitignore` includes:
```
.claude/settings.local.json
CLAUDE.local.md
.env
.env.local
.mcp.local.json
```

### Optional: Set Up Hooks

Make hooks executable:
```bash
chmod +x .claude/hooks/examples/*.sh
```

Enable hooks in `.claude/settings.json`:
```json
{
  "hooks": {
    "afterEdit": ".claude/hooks/examples/format-on-save.sh"
  }
}
```

### Optional: Create Personal Rules Repository

For sharing personal preferences across projects:

```bash
# Create a personal rules repo
mkdir -p ~/.claude-personal-rules
cd ~/.claude-personal-rules

# Move your personal rules there
mv ~/my-project/.claude/rules/personal/* .

# In each project, symlink personal rules
cd ~/my-project
rm -rf .claude/rules/personal
ln -s ~/.claude-personal-rules .claude/rules/personal
```

## Troubleshooting

### Claude Doesn't See Configuration

**Problem:** Claude doesn't seem to use your rules or CLAUDE.md

**Solutions:**
- Ensure `.claude/CLAUDE.md` exists and has content
- Check file permissions: `ls -la .claude/`
- Verify you're in the correct directory
- Restart Claude Code

### MCP Server Not Working

**Problem:** MCP server fails to start or connect

**Solutions:**
- Check environment variables are set: `echo $GITHUB_TOKEN`
- Verify server installation: `npx @modelcontextprotocol/server-github --version`
- Check `.mcp.json` syntax is valid JSON
- Review Claude Code logs for error messages
- Test server independently if possible

### Environment Variables Not Found

**Problem:** `${VAR_NAME}` not expanding in .mcp.json

**Solutions:**
- Ensure `.env` file exists and has correct format
- Export variables in your shell: `export GITHUB_TOKEN=ghp_...`
- Verify variable name matches exactly (case-sensitive)
- Restart your terminal/shell after setting variables
- Check Claude Code loads .env files in your setup

### Hooks Not Running

**Problem:** Hooks don't execute after edits

**Solutions:**
- Make hooks executable: `chmod +x .claude/hooks/examples/*.sh`
- Verify hook path in `.claude/settings.json`
- Check hook script for errors: `bash -n hook-script.sh`
- Review Claude Code logs for hook errors
- Test hook manually: `./.claude/hooks/examples/format-on-save.sh path/to/file`

### Rules Not Applied

**Problem:** Claude doesn't follow rules in `.claude/rules/`

**Solutions:**
- Verify file paths in YAML frontmatter are correct
- Check YAML syntax is valid
- Ensure rules are in markdown format
- Test with explicit rule references in CLAUDE.md
- Verify file structure matches expected layout

## Next Steps

Now that setup is complete:

1. **Test with Simple Requests**
   - Ask Claude about your project
   - Try MCP server commands
   - Verify rules are followed

2. **Customize Gradually**
   - Start with basic configuration
   - Add rules as you discover preferences
   - Refine based on experience

3. **Read the Guides**
   - [Customization Guide](docs/customization-guide.md) - Advanced customization
   - [MCP Servers Guide](docs/mcp-servers-guide.md) - Complete MCP reference
   - [Maintenance Guide](docs/maintenance-guide.md) - Keeping updated

4. **Share with Team**
   - Commit `.claude/` directory to your repo
   - Share MCP setup instructions
   - Document any custom configurations
   - Review and refine project rules together

## Getting Help

- **Documentation Issues:** Check the [docs/](docs/) directory
- **Template Issues:** [Open an issue](https://github.com/chrismalone617/claude-code-template/issues)
- **Claude Code Issues:** [Claude Code GitHub](https://github.com/anthropics/claude-code/issues)
- **MCP Server Issues:** Check individual server documentation

## Template Updates

To get updates to the template:

```bash
# Add template as remote
git remote add template https://github.com/chrismalone617/claude-code-template
git fetch template

# Merge updates (resolve conflicts as needed)
git merge template/main
```

See [Maintenance Guide](docs/maintenance-guide.md) for detailed update strategies.

---

**Congratulations!** Your Claude Code environment is now configured. Start coding with `claude`!
