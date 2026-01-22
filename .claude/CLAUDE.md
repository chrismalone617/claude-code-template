# Project Memory

<!--
This is Claude's main project memory file. Customize this template for each project.
Claude reads this file to understand your project context.
-->

## Project Overview

### What This Project Does
<!-- Brief description of what this project is and what it does (2-3 sentences) -->
[Describe your project here]

### Key Features
<!-- Main features or capabilities -->
- Feature 1
- Feature 2
- Feature 3

### Project Status
- **Phase**: [Planning / Development / Testing / Production]
- **Version**: [e.g., v1.2.0]
- **Team Size**: [Solo / Small team / Large team]
- **Active Development**: [Yes / Maintenance mode]

## Quick Commands

<!-- Common commands developers use - customize for your project -->

### Development
```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Type checking
npm run type-check

# Linting
npm run lint

# Format code
npm run format
```

### Testing
```bash
# Run all tests
npm test

# Run tests in watch mode
npm test -- --watch

# Run tests with coverage
npm run test:coverage

# Run E2E tests
npm run test:e2e
```

### Database
```bash
# Run migrations
npm run db:migrate

# Seed database
npm run db:seed

# Reset database
npm run db:reset

# Generate Prisma client
npm run db:generate
```

### Deployment
```bash
# Deploy to staging
npm run deploy:staging

# Deploy to production
npm run deploy:production

# Check deployment status
npm run deploy:status
```

## Architecture Overview

### Tech Stack
<!-- List main technologies used -->
- **Frontend**: [React, Vue, Angular, etc.]
- **Backend**: [Node.js, Python, Go, etc.]
- **Database**: [PostgreSQL, MongoDB, etc.]
- **Infrastructure**: [AWS, Docker, Kubernetes, etc.]
- **Other**: [Redis, RabbitMQ, etc.]

### Project Structure
```
src/
  ├── components/        # UI components
  ├── pages/            # Page components/routes
  ├── services/         # Business logic
  ├── utils/            # Utility functions
  ├── types/            # TypeScript types
  ├── hooks/            # Custom React hooks
  ├── api/              # API routes/endpoints
  ├── lib/              # Third-party integrations
  └── styles/           # Global styles
```

### Key Architectural Decisions
<!-- Important architectural choices and why they were made -->
- [Decision 1]: Rationale
- [Decision 2]: Rationale
- [Decision 3]: Rationale

### External Dependencies
<!-- Important external services or APIs -->
- **Service 1**: [Purpose and how it's used]
- **Service 2**: [Purpose and how it's used]
- **API Keys Required**: [List of required API keys/secrets]

## Important Locations

### Critical Files
<!-- Files that are central to understanding the project -->
- `src/index.ts` - Application entry point
- `src/routes.ts` - Route definitions
- `src/config.ts` - Configuration management
- `src/types/index.ts` - Core type definitions

### Configuration Files
- `.env.example` - Environment variables template
- `package.json` - Dependencies and scripts
- `tsconfig.json` - TypeScript configuration
- `.eslintrc.js` - Linting rules
- `.prettierrc` - Code formatting rules

### Documentation
- `docs/architecture.md` - Detailed architecture
- `docs/api.md` - API documentation
- `docs/deployment.md` - Deployment guide
- `CONTRIBUTING.md` - Contribution guidelines

## Development Workflow

### Getting Started
1. Clone the repository
2. Copy `.env.example` to `.env` and fill in values
3. Run `npm install`
4. Run `npm run dev`
5. Open http://localhost:3000

### Making Changes
1. Create a feature branch from `main`
2. Make your changes
3. Write/update tests
4. Run tests and linting
5. Commit with conventional commit message
6. Create pull request
7. Wait for review and CI to pass
8. Merge to main

### Code Review Process
- Minimum [1-2] reviewers required
- All CI checks must pass
- No unresolved comments
- Changes must include tests
- Documentation updated if needed

## Environment Variables

<!-- Document all required environment variables -->

### Required
```bash
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# API Keys
API_KEY=your_api_key_here

# App Configuration
NODE_ENV=development
PORT=3000
```

### Optional
```bash
# Feature Flags
FEATURE_NEW_UI=false

# External Services
SENTRY_DSN=https://...
ANALYTICS_KEY=...
```

## Common Tasks

### Adding a New Feature
1. Create feature branch: `git checkout -b feature/feature-name`
2. Add implementation in appropriate directory
3. Add tests in corresponding `.test.ts` file
4. Update types if needed
5. Add documentation
6. Create PR with description

### Debugging Issues
- Check logs: `npm run logs`
- Use debugger: Add breakpoints in VS Code
- Check database: `npm run db:console`
- View metrics: [Link to monitoring dashboard]

### Database Changes
1. Create migration: `npm run db:migration:create`
2. Edit migration file
3. Run migration: `npm run db:migrate`
4. Update Prisma schema if using Prisma
5. Generate types: `npm run db:generate`

## Project Rules

<!-- This section references detailed rules in .claude/rules/ -->

### Personal Preferences
Detailed preferences are in `.claude/rules/personal/`:
- Communication style: See `communication-style.md`
- Coding preferences: See `coding-style.md`
- Personal context: See `context.md`

### Project Requirements
Project-wide requirements are in `.claude/rules/project/`:
- Testing standards: See `testing.md`
- Documentation requirements: See `documentation.md`
- Security requirements: See `security.md`
- Code quality standards: See `quality.md`

## Known Issues

### Active Issues
<!-- Link to issue tracker or list known issues -->
- [Issue 1]: Brief description
- [Issue 2]: Brief description

### Technical Debt
<!-- Important technical debt to be aware of -->
- [Debt 1]: What needs to be refactored and why
- [Debt 2]: What needs to be refactored and why

### Workarounds
<!-- Temporary workarounds that should be removed later -->
- [Workaround 1]: Why it exists and when it can be removed
- [Workaround 2]: Why it exists and when it can be removed

## Team Conventions

### Branch Naming
- `feature/` - New features
- `fix/` - Bug fixes
- `refactor/` - Code refactoring
- `docs/` - Documentation changes
- `test/` - Test additions/changes

### Commit Messages
Follow [Conventional Commits](https://www.conventionalcommits.org/):
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation
- `style:` - Formatting
- `refactor:` - Code refactoring
- `test:` - Tests
- `chore:` - Maintenance

### Code Style
- Follow ESLint configuration
- Use Prettier for formatting
- TypeScript strict mode enabled
- Prefer functional components in React
- Use async/await over promises

## Resources

### Documentation
- [Link to external docs]
- [Link to design docs]
- [Link to API docs]

### Monitoring and Logs
- **Monitoring**: [Link to monitoring dashboard]
- **Logs**: [Link to log aggregation]
- **Errors**: [Link to error tracking (Sentry, etc.)]
- **Analytics**: [Link to analytics]

### Communication
- **Chat**: [Slack channel, Discord, etc.]
- **Issues**: [GitHub Issues, Jira, etc.]
- **Docs**: [Confluence, Notion, etc.]
- **Meetings**: [When and where]

## Notes for Claude

<!-- Specific instructions or context for Claude Code -->

### When Working on This Project
- Always run tests before committing
- Follow the error handling patterns in `src/utils/errors.ts`
- Use the logger in `src/lib/logger.ts` for all logging
- API endpoints follow REST conventions
- All database queries use Prisma ORM
- Frontend uses React with TypeScript and hooks

### Common Gotchas
- [Gotcha 1]: Explanation
- [Gotcha 2]: Explanation

### Preferred Patterns
- Use custom hooks for shared logic
- Prefer composition over inheritance
- Keep components small and focused
- Extract business logic to services
- Use TypeScript types, avoid `any`

---

**Last Updated**: [Date]
**Template Version**: 1.0.0

<!--
Tips for customizing this template:
- Remove sections that don't apply to your project
- Add project-specific sections as needed
- Keep it updated as the project evolves
- Link to external documentation rather than duplicating it
- Focus on what's unique to this project
-->
