# Quick Start Guide

Get up and running with the Claude Code template in under 5 minutes.

## 🚀 For a New Project

```bash
# 1. Clone the template
git clone https://github.com/chrismalone617/claude-code-template my-new-project
cd my-new-project

# 2. Run setup (interactive - it will guide you)
./setup.sh

# 3. Customize for your project (2 minutes)
nano .claude/CLAUDE.md    # Tell Claude about THIS project

# 4. Add your secrets
cp .env.example .env
nano .env                 # Add API keys, tokens, etc.

# 5. Start coding with Claude
claude
```

That's it! Claude now knows your preferences and project details.

## 📝 What to Customize

### 1. Project Details (`.claude/CLAUDE.md`)
Tell Claude about THIS specific project:
- What you're building
- Tech stack (React? Python? Go?)
- Important commands (npm run dev, pytest, etc.)
- Where files live (src/, tests/, etc.)

### 2. Tools/Integrations (`.mcp.json`)
Turn on the tools Claude can use:
- `github` - Create issues, PRs, search code
- `filesystem` - Read/write local files
- `postgres` - Query your database
- `brave-search` - Search the web
- `puppeteer` - Browser automation

See `.mcp.example.json` for all available tools.

### 3. Secrets (`.env`)
Add your API keys and tokens:
```bash
GITHUB_TOKEN=ghp_your_token_here
DATABASE_URL=postgresql://...
API_KEY=your_api_key
```

**Never commit `.env` to git!** (Already in .gitignore)

## 💡 Examples by Project Type

### Web App (React/Next.js)
```markdown
# In .claude/CLAUDE.md:
Tech Stack: React 18, TypeScript, Next.js 14, PostgreSQL

# In .mcp.json - enable:
- github
- postgres
- filesystem
```

### Python Data Science
```markdown
# In .claude/CLAUDE.md:
Tech Stack: Python 3.11, pandas, scikit-learn, Jupyter

# In .mcp.json - enable:
- filesystem
- postgres (for data)
```

### Backend API (Node/Express)
```markdown
# In .claude/CLAUDE.md:
Tech Stack: Node.js, Express, TypeScript, PostgreSQL

# In .mcp.json - enable:
- github
- postgres
- filesystem
```

### Simple Website
```markdown
# In .claude/CLAUDE.md:
Tech Stack: HTML, CSS, vanilla JavaScript

# In .mcp.json - enable:
- filesystem
- puppeteer (for testing)
```

## 🎯 Common Commands

```bash
# Start Claude Code
claude

# View project memory
cat .claude/CLAUDE.md

# View active MCP servers
cat .mcp.json

# View all available MCP examples
cat .mcp.example.json

# Check your environment variables
cat .env
```

## 📚 Learn More

- **README.md** - Full overview and features
- **SETUP.md** - Detailed setup instructions
- **docs/mcp-servers-guide.md** - Complete MCP reference (60+ examples)
- **docs/customization-guide.md** - Advanced customization
- **docs/maintenance-guide.md** - Keeping your config updated

## 🔧 Personal Preferences (Optional)

Want Claude to communicate differently or follow different coding styles?

Edit these files:
- `.claude/rules/personal/communication-style.md` - How Claude talks
- `.claude/rules/personal/coding-style.md` - Your code preferences
- `.claude/rules/personal/context.md` - Your background/skills

## 💭 Key Concepts

**Think of this template as:**
- A "handbook" for Claude about how you work
- Settings that persist across conversations
- Project-specific context Claude always remembers

**Without template:** Tell Claude your preferences every time
**With template:** Set preferences once, Claude remembers forever

## 🆘 Troubleshooting

**Claude doesn't seem to follow my rules:**
- Check file exists: `ls -la .claude/CLAUDE.md`
- Restart Claude Code
- Verify you're in the right directory

**MCP server not working:**
- Check environment variables: `echo $GITHUB_TOKEN`
- Verify `.mcp.json` syntax (must be valid JSON)
- Check Claude Code logs for errors

**Setup script fails:**
- Make sure it's executable: `chmod +x setup.sh`
- Run with bash: `bash setup.sh`

## 🎓 Pro Tips

1. **Share Personal Rules Across Projects:**
   ```bash
   # Create once
   mkdir ~/.my-claude-preferences

   # Link in each project
   ln -s ~/.my-claude-preferences .claude/rules/personal
   ```

2. **Use `.mcp.local.json` for machine-specific tools:**
   - Not committed to git
   - Different on laptop vs desktop
   - Personal overrides

3. **Keep `.claude/CLAUDE.md` updated:**
   - Update when architecture changes
   - Add new commands as you create them
   - Document important decisions

4. **Start simple, add complexity gradually:**
   - Don't over-configure initially
   - Add rules as you discover preferences
   - Test with simple requests first

## ✅ Checklist

Before starting development:
- [ ] Ran `./setup.sh`
- [ ] Edited `.claude/CLAUDE.md` with project details
- [ ] Configured `.mcp.json` with needed tools
- [ ] Created `.env` with secrets
- [ ] Tested with `claude` - asked Claude about the project

---

**Need Help?**
- [Open an issue](https://github.com/chrismalone617/claude-code-template/issues)
- Check [SETUP.md](SETUP.md) for detailed instructions
- Read the [documentation guides](docs/)

**Ready to build something awesome!** 🚀
