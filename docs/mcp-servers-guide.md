# MCP Servers Guide

Complete reference for Model Context Protocol (MCP) servers with Claude Code.

## What are MCP Servers?

MCP servers extend Claude Code's capabilities by providing access to external tools, data sources, and services. They run as separate processes and communicate with Claude via the Model Context Protocol.

## Server Types

### stdio (Standard Input/Output)
Local processes that communicate via stdin/stdout.

```json
{
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-github"]
}
```

**Use for:** Local servers, npm packages, command-line tools

### sse (Server-Sent Events)
Remote servers accessed via HTTP with Server-Sent Events.

```json
{
  "type": "sse",
  "url": "https://api.example.com/mcp",
  "headers": {
    "Authorization": "Bearer ${API_TOKEN}"
  }
}
```

**Use for:** Remote services, cloud-hosted servers, shared team servers

## Official MCP Servers

### GitHub
**Purpose:** Interact with GitHub repositories, issues, PRs

```json
{
  "github": {
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-github"],
    "env": {
      "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
    }
  }
}
```

**Setup:**
1. Create token at https://github.com/settings/tokens
2. Required scopes: `repo`, `read:org`
3. Export as `GITHUB_TOKEN` environment variable

**Capabilities:**
- Create and update issues
- Create and manage pull requests
- Search repositories and code
- Manage branches and commits
- Read repository contents

**Example Usage:**
```
"Create an issue for the bug we just found"
"Show me all open PRs"
"Search for authentication code in this repo"
```

---

### Filesystem
**Purpose:** Read, write, and search local files

```json
{
  "filesystem": {
    "type": "stdio",
    "command": "npx",
    "args": [
      "-y",
      "@modelcontextprotocol/server-filesystem",
      "/path/to/allowed/directory"
    ]
  }
}
```

**Setup:**
- Specify allowed directories as arguments
- Can provide multiple paths
- Restricts access to specified directories only

**Security Note:** Only grant access to directories Claude should modify.

**Capabilities:**
- Read file contents
- Write and update files
- Search file contents
- List directories
- Create directories

**Example Usage:**
```
"Read all TypeScript files in src/"
"Update the configuration in config.json"
"Search for TODO comments across the codebase"
```

---

### PostgreSQL
**Purpose:** Query PostgreSQL databases, inspect schema

```json
{
  "postgres": {
    "type": "stdio",
    "command": "npx",
    "args": [
      "-y",
      "@modelcontextprotocol/server-postgres",
      "${DATABASE_URL}"
    ]
  }
}
```

**Setup:**
1. Set `DATABASE_URL` environment variable
2. Format: `postgresql://user:password@host:port/database`
3. Consider using read-only user for safety

**Capabilities:**
- Execute SQL queries
- Inspect database schema
- View table definitions
- Analyze query results
- Generate sample queries

**Security:** Use read-only database user when possible.

**Example Usage:**
```
"Show me the schema for the users table"
"Query all users created in the last week"
"Help me optimize this slow query"
```

---

### Sequential Thinking
**Purpose:** Extended reasoning for complex problems

```json
{
  "sequential-thinking": {
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
  }
}
```

**Setup:** No configuration required

**Capabilities:**
- Extended thinking time for complex problems
- Step-by-step reasoning
- Problem decomposition
- Complex debugging assistance

**When to Use:**
- Debugging complex issues
- Architecture decisions
- Algorithm design
- Multi-step problem solving

**Example Usage:**
```
"Help me design the architecture for this feature"
"Debug why this algorithm isn't working"
"What's the best approach for scaling this service?"
```

---

### Brave Search
**Purpose:** Web search capabilities

```json
{
  "brave-search": {
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-brave-search"],
    "env": {
      "BRAVE_API_KEY": "${BRAVE_API_KEY}"
    }
  }
}
```

**Setup:**
1. Sign up at https://brave.com/search/api/
2. Free tier: 2,000 queries/month
3. Set `BRAVE_API_KEY` environment variable

**Capabilities:**
- Web search
- Current information
- Documentation lookup
- Technology research

**Example Usage:**
```
"Search for the latest React best practices"
"Find documentation for the Stripe API"
"What are current TypeScript trends?"
```

---

### Puppeteer
**Purpose:** Browser automation and web scraping

```json
{
  "puppeteer": {
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
  }
}
```

**Setup:**
- Requires Chrome/Chromium installed
- No additional configuration needed

**Capabilities:**
- Take screenshots
- Scrape web content
- Test web UIs
- Automate browser tasks
- Fill out forms

**Example Usage:**
```
"Take a screenshot of example.com"
"Test the login flow on our staging site"
"Scrape product prices from this page"
```

---

### Slack
**Purpose:** Send messages and read channels in Slack

```json
{
  "slack": {
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-slack"],
    "env": {
      "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}",
      "SLACK_TEAM_ID": "${SLACK_TEAM_ID}"
    }
  }
}
```

**Setup:**
1. Create Slack app at https://api.slack.com/apps
2. Add bot token scopes:
   - `channels:history`
   - `channels:read`
   - `chat:write`
   - `users:read`
3. Install to workspace
4. Set environment variables

**Capabilities:**
- Send messages to channels
- Read channel history
- List channels and users
- Post updates

**Example Usage:**
```
"Post this error to #alerts channel"
"Check recent messages in #engineering"
"Notify the team about the deployment"
```

---

### Memory
**Purpose:** Long-term memory across Claude sessions

```json
{
  "memory": {
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-memory"]
  }
}
```

**Setup:** No configuration required

**Capabilities:**
- Store knowledge across sessions
- Remember user preferences
- Build knowledge graphs
- Persistent project context

**Example Usage:**
```
"Remember that I prefer TypeScript over JavaScript"
"What did we discuss about the authentication system?"
"Store this API design decision"
```

---

### SQLite
**Purpose:** SQLite database access

```json
{
  "sqlite": {
    "type": "stdio",
    "command": "npx",
    "args": [
      "-y",
      "@modelcontextprotocol/server-sqlite",
      "/path/to/database.db"
    ]
  }
}
```

**Setup:** Provide path to SQLite database file

**Capabilities:**
- Execute SQL queries
- Inspect schema
- Manage local databases

**Example Usage:**
```
"Query the local cache database"
"Show tables in the SQLite database"
```

---

### Git
**Purpose:** Advanced Git operations

```json
{
  "git": {
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-git"]
  }
}
```

**Setup:** No configuration required

**Capabilities:**
- Complex Git workflows
- Repository analysis
- Automated Git operations
- History inspection

**Example Usage:**
```
"Analyze the commit history for this feature"
"Help me resolve this merge conflict"
"Create a feature branch with proper naming"
```

---

## Community Servers

See [Awesome MCP Servers](https://github.com/punkpeye/awesome-mcp-servers) for community-maintained servers:

- **Docker** - Container management
- **Kubernetes** - K8s cluster operations
- **AWS** - AWS service integration
- **MongoDB** - MongoDB database access
- **Redis** - Redis cache operations
- **Notion** - Notion workspace integration
- **Linear** - Linear issue tracking
- And many more...

## Building Custom Servers

### Basic Structure

```javascript
// my-mcp-server.js
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';

const server = new Server({
  name: 'my-custom-server',
  version: '1.0.0'
});

// Define tools
server.setRequestHandler('tools/list', async () => ({
  tools: [
    {
      name: 'my_tool',
      description: 'What this tool does',
      inputSchema: {
        type: 'object',
        properties: {
          param: { type: 'string', description: 'Parameter description' }
        }
      }
    }
  ]
}));

// Handle tool calls
server.setRequestHandler('tools/call', async (request) => {
  if (request.params.name === 'my_tool') {
    // Tool implementation
    return {
      content: [{ type: 'text', text: 'Result' }]
    };
  }
});

// Start server
const transport = new StdioServerTransport();
await server.connect(transport);
```

### Using Custom Server

```json
{
  "my-custom-server": {
    "type": "stdio",
    "command": "node",
    "args": ["/path/to/my-mcp-server.js"],
    "env": {
      "API_KEY": "${MY_API_KEY}"
    }
  }
}
```

### Resources

- **[MCP Documentation](https://modelcontextprotocol.io/docs)** - Official docs
- **[MCP SDK](https://github.com/modelcontextprotocol/sdk)** - TypeScript SDK
- **[Server Examples](https://github.com/modelcontextprotocol/servers)** - Reference implementations

## Security Considerations

### Best Practices

1. **Least Privilege**
   - Only enable servers you need
   - Use read-only access when possible
   - Restrict filesystem access to specific directories

2. **Secret Management**
   - Never commit secrets to git
   - Use environment variables for all secrets
   - Rotate API keys regularly

3. **Access Control**
   - Review server permissions
   - Audit server access logs
   - Monitor for unusual activity

4. **Updates**
   - Keep servers updated
   - Review changelogs for security fixes
   - Test updates in development first

### Environment Variables

Store secrets in `.env` (gitignored):
```bash
GITHUB_TOKEN=ghp_...
DATABASE_URL=postgresql://...
API_KEY=sk_...
```

Reference in `.mcp.json`:
```json
{
  "env": {
    "API_KEY": "${API_KEY}"
  }
}
```

## Troubleshooting

### Server Won't Start

**Symptoms:** Server fails to initialize

**Checks:**
- Verify command/path is correct
- Check environment variables are set
- Test command manually: `npx @modelcontextprotocol/server-github`
- Review error logs

### Authentication Failures

**Symptoms:** "Unauthorized" or authentication errors

**Checks:**
- Verify API keys/tokens are correct
- Check token hasn't expired
- Verify required scopes/permissions
- Test credentials independently

### Performance Issues

**Symptoms:** Slow responses, timeouts

**Solutions:**
- Reduce number of active servers
- Optimize server queries
- Use caching where possible
- Consider local alternatives to remote servers

### Debugging Servers

```bash
# Test server independently
npx @modelcontextprotocol/server-github

# Check environment variables
echo $GITHUB_TOKEN

# Verify server installation
npm list -g @modelcontextprotocol/server-github

# Review Claude Code logs
claude --verbose
```

## Tips

- Start with 1-2 servers and add more as needed
- Use `.mcp.local.json` for machine-specific servers
- Document required environment variables in your README
- Test servers independently before adding to Claude
- Keep `.mcp.example.json` as reference
- Review official server docs for advanced features

---

**Next:** [Customization Guide](customization-guide.md) - Learn how to customize your Claude Code configuration.
