#!/bin/bash

# Claude Code Template Setup Script
# This script helps set up the Claude Code configuration for a new project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
  echo -e "\n${BLUE}=== $1 ===${NC}\n"
}

print_success() {
  echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
  echo -e "${RED}✗${NC} $1"
}

print_info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

prompt_yes_no() {
  local prompt="$1"
  local default="${2:-n}"

  if [ "$default" = "y" ]; then
    prompt="$prompt [Y/n]: "
  else
    prompt="$prompt [y/N]: "
  fi

  read -r -p "$prompt" response
  response=${response:-$default}

  [[ "$response" =~ ^[Yy] ]]
}

# Welcome message
clear
echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║        Claude Code Project Template Setup                ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo "This script will help you set up Claude Code configuration"
echo "for your project."
echo ""

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  print_warning "Not in a git repository"
  if prompt_yes_no "Initialize git repository?"; then
    git init
    print_success "Git repository initialized"
  fi
fi

# Check prerequisites
print_header "Checking Prerequisites"

# Check for Claude Code
if command -v claude &> /dev/null; then
  CLAUDE_VERSION=$(claude --version 2>/dev/null || echo "unknown")
  print_success "Claude Code installed: $CLAUDE_VERSION"
else
  print_warning "Claude Code not found"
  print_info "Install with: npm install -g @anthropic/claude-code"
fi

# Check for Node.js (for MCP servers)
if command -v node &> /dev/null; then
  NODE_VERSION=$(node --version)
  print_success "Node.js installed: $NODE_VERSION"
else
  print_warning "Node.js not found (required for MCP servers)"
  print_info "Install from: https://nodejs.org/"
fi

# Verify directory structure
print_header "Verifying Directory Structure"

DIRS=(
  ".claude"
  ".claude/rules"
  ".claude/rules/personal"
  ".claude/rules/project"
  ".claude/rules/examples"
  ".claude/skills"
  ".claude/skills/examples"
  ".claude/hooks"
  ".claude/hooks/examples"
  "docs"
)

for dir in "${DIRS[@]}"; do
  if [ -d "$dir" ]; then
    print_success "$dir exists"
  else
    mkdir -p "$dir"
    print_success "$dir created"
  fi
done

# Check for required files
print_header "Checking Configuration Files"

FILES_TO_CHECK=(
  ".claude/CLAUDE.md"
  ".mcp.json"
  ".mcp.example.json"
  ".gitignore"
  "README.md"
  "SETUP.md"
)

for file in "${FILES_TO_CHECK[@]}"; do
  if [ -f "$file" ]; then
    print_success "$file exists"
  else
    print_warning "$file missing"
  fi
done

# Customize CLAUDE.md
print_header "Project Configuration"

if [ -f ".claude/CLAUDE.md" ]; then
  if prompt_yes_no "Customize .claude/CLAUDE.md for this project?"; then
    echo ""
    read -r -p "Project description: " PROJECT_DESC

    # Update CLAUDE.md with project info
    sed -i.bak "s/\[Describe your project here\]/$PROJECT_DESC/" .claude/CLAUDE.md 2>/dev/null || \
      sed -i '' "s/\[Describe your project here\]/$PROJECT_DESC/" .claude/CLAUDE.md 2>/dev/null

    rm -f .claude/CLAUDE.md.bak
    print_success "Updated CLAUDE.md with project information"
  fi
fi

# Set up environment variables
print_header "Environment Variables"

if [ ! -f ".env" ]; then
  if prompt_yes_no "Create .env file?"; then
    cat > .env <<'EOF'
# Claude Code Environment Variables
# Copy this file and fill in your values

# GitHub Integration
# Create token at: https://github.com/settings/tokens
# GITHUB_TOKEN=ghp_your_token_here

# Database (if using)
# DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# Web Search (if using Brave Search)
# BRAVE_API_KEY=your_brave_api_key

# Custom API Keys
# API_KEY=your_api_key

# Node Environment
NODE_ENV=development
EOF
    print_success "Created .env file template"
    print_info "Edit .env to add your secrets"
  fi
else
  print_success ".env file already exists"
fi

# Configure MCP servers
print_header "MCP Server Configuration"

print_info "Available MCP servers in .mcp.example.json:"
echo "  - github: GitHub integration"
echo "  - filesystem: Local file access"
echo "  - postgres: PostgreSQL database"
echo "  - sequential-thinking: Extended reasoning"
echo "  - brave-search: Web search"
echo "  - puppeteer: Browser automation"
echo "  - slack: Slack integration"
echo "  - memory: Long-term memory"
echo ""
print_info "Review .mcp.example.json for complete list and configuration"
echo ""

if [ -f ".mcp.json" ]; then
  print_success "MCP configuration exists"
  if prompt_yes_no "Review MCP configuration?"; then
    echo ""
    cat .mcp.json
    echo ""
  fi
fi

# Customize personal preferences
print_header "Personal Preferences"

if prompt_yes_no "Customize personal preferences now?"; then
  echo ""
  print_info "Personal preferences are in .claude/rules/personal/"
  print_info "You can customize these files:"
  echo "  - communication-style.md: How Claude communicates"
  echo "  - coding-style.md: Your coding preferences"
  echo "  - context.md: Your background and environment"
  echo ""

  if prompt_yes_no "Open communication-style.md in editor?"; then
    ${EDITOR:-nano} .claude/rules/personal/communication-style.md
    print_success "Updated communication-style.md"
  fi
fi

# Make hook scripts executable
print_header "Setting Up Hooks"

if [ -d ".claude/hooks/examples" ]; then
  chmod +x .claude/hooks/examples/*.sh 2>/dev/null || true
  print_success "Made hook scripts executable"
fi

# Git configuration
print_header "Git Configuration"

if git rev-parse --git-dir > /dev/null 2>&1; then
  # Check if .gitignore includes necessary entries
  GITIGNORE_ENTRIES=(
    ".claude/settings.local.json"
    "CLAUDE.local.md"
    ".env"
    ".env.local"
    ".mcp.local.json"
  )

  MISSING_ENTRIES=()
  for entry in "${GITIGNORE_ENTRIES[@]}"; do
    if ! grep -q "$entry" .gitignore 2>/dev/null; then
      MISSING_ENTRIES+=("$entry")
    fi
  done

  if [ ${#MISSING_ENTRIES[@]} -gt 0 ]; then
    print_warning "Some entries missing from .gitignore"
    if prompt_yes_no "Add missing entries to .gitignore?"; then
      for entry in "${MISSING_ENTRIES[@]}"; do
        echo "$entry" >> .gitignore
      done
      print_success "Updated .gitignore"
    fi
  else
    print_success ".gitignore properly configured"
  fi

  # Offer to make initial commit
  if ! git log -1 > /dev/null 2>&1; then
    if prompt_yes_no "Create initial git commit?"; then
      git add .
      git commit -m "Initial commit with Claude Code template"
      print_success "Created initial commit"
    fi
  fi
fi

# Create .env.example if it doesn't exist
if [ ! -f ".env.example" ] && [ -f ".env" ]; then
  if prompt_yes_no "Create .env.example from .env?"; then
    # Copy .env but remove actual values
    grep -v "^#" .env | sed 's/=.*/=/' > .env.example
    cat .env.example
    print_success "Created .env.example"
  fi
fi

# Summary and next steps
print_header "Setup Complete!"

echo ""
echo "Your Claude Code configuration is ready!"
echo ""
echo -e "${GREEN}Next Steps:${NC}"
echo ""
echo "1. Customize Configuration:"
echo "   - Edit .claude/CLAUDE.md for project-specific information"
echo "   - Review .claude/rules/personal/ for your preferences"
echo "   - Adjust .claude/rules/project/ for project requirements"
echo ""
echo "2. Configure MCP Servers:"
echo "   - Review .mcp.example.json for available servers"
echo "   - Edit .mcp.json to enable servers you need"
echo "   - Set required environment variables in .env"
echo ""
echo "3. Test Configuration:"
echo "   - Run: claude"
echo "   - Try: 'What is this project?'"
echo "   - Try: 'What are the testing requirements?'"
echo ""
echo "4. Read Documentation:"
echo "   - SETUP.md: Detailed setup instructions"
echo "   - docs/mcp-servers-guide.md: MCP reference"
echo "   - docs/customization-guide.md: Advanced customization"
echo "   - docs/maintenance-guide.md: Keeping updated"
echo ""
echo -e "${BLUE}Helpful Commands:${NC}"
echo "   claude                    # Start Claude Code"
echo "   cat .claude/CLAUDE.md     # View project memory"
echo "   cat .mcp.json             # View MCP configuration"
echo ""
echo -e "${YELLOW}Important Files:${NC}"
echo "   .claude/CLAUDE.md         # Main project memory"
echo "   .claude/rules/            # Rules and preferences"
echo "   .mcp.json                 # Active MCP servers"
echo "   .env                      # Environment variables (secret)"
echo ""

if [ -f ".env" ]; then
  print_warning "Remember to fill in your secrets in .env"
fi

echo ""
echo -e "${GREEN}Happy coding with Claude! 🚀${NC}"
echo ""

# Optional: Start Claude Code
if command -v claude &> /dev/null; then
  if prompt_yes_no "Start Claude Code now?"; then
    echo ""
    exec claude
  fi
fi
