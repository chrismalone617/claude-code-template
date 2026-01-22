# Maintenance Guide

Learn how to keep your Claude Code configuration updated and synchronized across projects.

## Table of Contents

- [Updating the Template](#updating-the-template)
- [Syncing Across Projects](#syncing-across-projects)
- [Version Control Strategy](#version-control-strategy)
- [Personal Rules Management](#personal-rules-management)
- [MCP Server Updates](#mcp-server-updates)
- [Backup Strategies](#backup-strategies)
- [Troubleshooting](#troubleshooting)

## Updating the Template

### Getting Template Updates

If you cloned the template from a Git repository:

```bash
# Add template as a remote (if not already added)
git remote add template https://github.com/chrismalone617/claude-code-template.git

# Fetch updates from template
git fetch template

# View changes
git log HEAD..template/main

# Merge updates
git merge template/main
```

### Handling Merge Conflicts

When merging template updates, conflicts may occur:

```bash
# Merge and handle conflicts
git merge template/main

# View conflicting files
git status

# Resolve conflicts
# Edit files to resolve conflicts
# Keep your customizations where appropriate
# Accept template improvements where applicable

# Stage resolved files
git add .

# Complete merge
git commit
```

### Selective Updates

Cherry-pick specific improvements:

```bash
# View template commits
git log template/main

# Cherry-pick specific commit
git cherry-pick <commit-hash>
```

### Update Checklist

When updating template:

- [ ] Review changelog for breaking changes
- [ ] Test in development environment first
- [ ] Update customizations if needed
- [ ] Verify MCP servers still work
- [ ] Check rules are still valid
- [ ] Update documentation if structure changed
- [ ] Test with sample Claude requests

## Syncing Across Projects

### Strategy 1: Manual Sync

Keep a master template and manually copy to projects:

```bash
# Update master template
cd ~/claude-code-template
git pull

# Copy to project
cd ~/my-project
cp -r ~/claude-code-template/.claude .
cp ~/claude-code-template/.mcp.example.json .

# Customize for project
nano .claude/CLAUDE.md
```

**Pros:** Full control, simple
**Cons:** Manual effort, can drift

### Strategy 2: Git Subtree

Use git subtree for shared configuration:

```bash
# Add template as subtree
git subtree add \
  --prefix=.claude-template \
  https://github.com/chrismalone617/claude-code-template.git \
  main \
  --squash

# Update template
git subtree pull \
  --prefix=.claude-template \
  https://github.com/chrismalone617/claude-code-template.git \
  main \
  --squash

# Copy updated files to .claude/
cp -r .claude-template/.claude/* .claude/
```

**Pros:** Version controlled, traceable
**Cons:** More complex, requires git knowledge

### Strategy 3: Symlinks for Personal Rules

Share personal rules across all projects:

```bash
# Create personal rules repository
mkdir -p ~/.claude-personal-rules
cd ~/.claude-personal-rules
git init

# Create rules
echo "# My Communication Style" > communication-style.md
echo "# My Coding Style" > coding-style.md
echo "# My Context" > context.md

# In each project, symlink personal rules
cd ~/project1
ln -s ~/.claude-personal-rules .claude/rules/personal

cd ~/project2
ln -s ~/.claude-personal-rules .claude/rules/personal
```

**Pros:** Single source of truth, automatic sync
**Cons:** Same preferences across all projects

### Strategy 4: Template Repository

Use GitHub template repository feature:

1. Make your template a GitHub template repository
2. For new projects, click "Use this template"
3. Clone the new repository
4. Customize for the project

**Pros:** Clean start for each project
**Cons:** No automatic updates

## Version Control Strategy

### What to Commit

#### Always Commit
✅ `.claude/CLAUDE.md` - Project memory
✅ `.claude/rules/project/` - Project requirements
✅ `.claude/rules/examples/` - Example rules
✅ `.claude/skills/` - Custom skills
✅ `.claude/hooks/` - Hook scripts
✅ `.claude/settings.json` - Shared settings
✅ `.mcp.json` - Active MCP servers
✅ `.mcp.example.json` - MCP examples
✅ `.gitignore` - Ignore patterns

#### Never Commit
❌ `.claude/settings.local.json` - Personal overrides
❌ `.env` - Environment variables
❌ `.mcp.local.json` - Local MCP overrides
❌ `CLAUDE.local.md` - Personal notes

#### Optional
⚠️ `.claude/rules/personal/` - Personal preferences
   - Commit for solo projects
   - Exclude for team projects
   - Or symlink to personal repository

### .gitignore Configuration

Ensure `.gitignore` includes:

```gitignore
# Claude Code personal configuration
.claude/settings.local.json
CLAUDE.local.md

# MCP local overrides
.mcp.local.json

# Environment variables
.env
.env.local
.env.*.local

# Personal rules (optional)
# .claude/rules/personal/
```

### Branching Strategy

For template updates:

```bash
# Create branch for template update
git checkout -b update-claude-template

# Fetch and merge template
git fetch template
git merge template/main

# Resolve conflicts, test changes
# ...

# Commit and push
git commit -m "Update Claude Code template"
git push origin update-claude-template

# Create PR for review
```

## Personal Rules Management

### Option 1: Separate Repository

Create a personal rules repository:

```bash
# Initialize personal rules repo
mkdir ~/.claude-personal-rules
cd ~/.claude-personal-rules
git init
git remote add origin git@github.com:you/claude-personal-rules.git

# Create rules
cat > communication-style.md <<EOF
# My Communication Style
- Concise and technical
- Use examples
EOF

git add .
git commit -m "Initial personal rules"
git push -u origin main
```

Link in projects:

```bash
# Clone personal rules
cd ~/
git clone git@github.com:you/claude-personal-rules.git .claude-personal-rules

# Link in each project
cd ~/project
rm -rf .claude/rules/personal
ln -s ~/.claude-personal-rules .claude/rules/personal
```

**Update Personal Rules:**

```bash
cd ~/.claude-personal-rules
# Edit rules
git add .
git commit -m "Update communication style"
git push

# Changes automatically apply to all projects
```

### Option 2: Per-Project Personal Rules

Keep personal rules in each project:

```bash
# Commit personal rules to project
git add .claude/rules/personal/
git commit -m "Add personal Claude preferences"
```

**Pros:** Project-specific preferences
**Cons:** Must update in each project

### Option 3: Hybrid Approach

Share common rules, customize per project:

```bash
# Symlink common rules
ln -s ~/.claude-personal-rules/communication-style.md \
  .claude/rules/personal/communication-style.md
ln -s ~/.claude-personal-rules/coding-style.md \
  .claude/rules/personal/coding-style.md

# Keep project-specific context
nano .claude/rules/personal/context.md
```

## MCP Server Updates

### Checking for Updates

```bash
# Check for outdated MCP servers
npm outdated -g @modelcontextprotocol/server-*

# Update specific server
npm update -g @modelcontextprotocol/server-github

# Update all MCP servers
npm update -g @modelcontextprotocol/server-*
```

### Testing After Updates

```bash
# Test individual server
npx @modelcontextprotocol/server-github --version

# Test in Claude Code
claude
# Try using the updated server
```

### Tracking MCP Versions

Document server versions in `.mcp.json`:

```json
{
  "_versions": {
    "last_updated": "2024-01-15",
    "server-github": "1.2.0",
    "server-filesystem": "1.0.5"
  },
  "mcpServers": {
    ...
  }
}
```

### MCP Server Changelog

Keep a changelog of MCP updates:

```markdown
# MCP Server Updates

## 2024-01-15
- Updated server-github to 1.2.0
  - Added PR review capabilities
  - Fixed issue search bug
- Updated server-filesystem to 1.0.5
  - Performance improvements
```

## Backup Strategies

### Configuration Backup

Regular backups of Claude configuration:

```bash
# Create backup script
cat > backup-claude-config.sh <<'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d)
BACKUP_DIR=~/.claude-backups

mkdir -p $BACKUP_DIR

# Backup all projects
for project in ~/projects/*; do
  if [ -d "$project/.claude" ]; then
    PROJECT_NAME=$(basename "$project")
    tar -czf "$BACKUP_DIR/${PROJECT_NAME}-${DATE}.tar.gz" \
      -C "$project" .claude .mcp.json
  fi
done

# Keep only last 30 days
find $BACKUP_DIR -name "*.tar.gz" -mtime +30 -delete
EOF

chmod +x backup-claude-config.sh
```

Run automatically:

```bash
# Add to crontab (daily at 2 AM)
0 2 * * * ~/backup-claude-config.sh
```

### Cloud Backup

Backup to cloud storage:

```bash
# Sync to cloud (example with rclone)
rclone sync ~/.claude-backups remote:claude-backups
```

### Git-Based Backup

Use git for versioned backups:

```bash
# Create backup repo
mkdir ~/.claude-config-backup
cd ~/.claude-config-backup
git init

# Backup script
cat > backup.sh <<'EOF'
#!/bin/bash
cd ~/.claude-config-backup

# Copy configurations
for project in ~/projects/*; do
  if [ -d "$project/.claude" ]; then
    PROJECT_NAME=$(basename "$project")
    mkdir -p "$PROJECT_NAME"
    cp -r "$project/.claude" "$PROJECT_NAME/"
    cp "$project/.mcp.json" "$PROJECT_NAME/" 2>/dev/null
  fi
done

# Commit changes
git add .
git commit -m "Backup $(date +%Y-%m-%d)"
git push
EOF

chmod +x backup.sh
```

## Troubleshooting

### Configuration Not Applying

**Problem:** Changes to rules not taking effect

**Solutions:**
1. Restart Claude Code
2. Check file syntax (YAML frontmatter, Markdown format)
3. Verify file paths are correct
4. Check file permissions: `ls -la .claude/`
5. Test with simple rule to isolate issue

### Merge Conflicts

**Problem:** Conflicts when updating template

**Solutions:**
1. Understand what changed in both versions
2. Keep project-specific customizations
3. Accept template improvements for structure
4. Test after resolving each conflict
5. When in doubt, keep your version and manually apply template changes

### Sync Issues

**Problem:** Personal rules out of sync across projects

**Solutions:**
1. Verify symlinks: `ls -la .claude/rules/personal`
2. Check symlink target: `readlink .claude/rules/personal`
3. Re-create symlinks if broken
4. Use git to track personal rules repo
5. Pull latest from personal rules repo

### Performance Issues

**Problem:** Claude Code slow after configuration updates

**Solutions:**
1. Reduce number of active MCP servers
2. Simplify complex rules
3. Check for large files in `.claude/`
4. Disable unused features
5. Profile to identify bottlenecks

## Best Practices

### Regular Maintenance

Schedule regular maintenance:

- **Weekly:** Review and update personal rules
- **Monthly:** Check for template updates
- **Quarterly:** Audit MCP servers and dependencies
- **Annually:** Major configuration review and cleanup

### Documentation

Keep maintenance documentation:

```markdown
# Maintenance Log

## 2024-01-15
- Updated template to v1.2
- Added new testing rules
- Updated MCP servers
- Issues: None

## 2024-01-01
- Annual configuration review
- Removed unused rules
- Consolidated personal preferences
- Issues: Fixed symlink in project A
```

### Testing Changes

Always test configuration changes:

```bash
# Create test script
cat > test-config.sh <<'EOF'
#!/bin/bash
echo "Testing Claude Code configuration..."

# Test 1: Files exist
[ -f .claude/CLAUDE.md ] || echo "ERROR: CLAUDE.md missing"
[ -f .mcp.json ] || echo "ERROR: .mcp.json missing"

# Test 2: Valid JSON
jq empty .mcp.json 2>/dev/null || echo "ERROR: Invalid .mcp.json"

# Test 3: MCP servers
echo "Testing MCP servers..."
# Add specific server tests

echo "Tests complete"
EOF

chmod +x test-config.sh
./test-config.sh
```

### Version Tracking

Track configuration versions:

```markdown
# .claude/VERSION.md

## Configuration Version: 2.1.0

### Changes in 2.1.0 (2024-01-15)
- Updated testing requirements
- Added security rules
- New MCP server configurations

### Changes in 2.0.0 (2024-01-01)
- Major restructure of rules
- Migrated to new template format
- Breaking changes: See MIGRATION.md
```

---

**Related Guides:**
- [Setup Guide](../SETUP.md) - Initial setup instructions
- [Customization Guide](customization-guide.md) - How to customize
- [MCP Servers Guide](mcp-servers-guide.md) - MCP reference
