# Code Quality Standards

<!--
This file defines code quality standards and best practices for this project.
High-quality code is maintainable, reliable, and a joy to work with.
-->

## Code Quality Principles

### Core Values
- **Readability**: Code is read more often than written
- **Simplicity**: Simple solutions over clever ones
- **Consistency**: Follow established patterns
- **Maintainability**: Easy to change and extend
- **Reliability**: Works correctly and handles errors gracefully

### Quality Goals
- **Bug-Free**: Minimize defects through testing and review
- **Performant**: Meets performance requirements
- **Secure**: Free from security vulnerabilities
- **Scalable**: Can grow with requirements
- **Documented**: Understandable by others (and future you)

## Code Review Standards

### Every Code Change Must
- [ ] Follow project coding style
- [ ] Include relevant tests
- [ ] Pass all existing tests
- [ ] Pass linting and formatting checks
- [ ] Update documentation if needed
- [ ] Handle errors appropriately
- [ ] Be reviewed by at least one other developer

### Code Review Checklist
- **Correctness**: Does it work as intended?
- **Testing**: Are there adequate tests?
- **Readability**: Is it easy to understand?
- **Maintainability**: Will it be easy to change later?
- **Performance**: Are there obvious performance issues?
- **Security**: Are there security concerns?
- **Design**: Does it fit the overall architecture?

### Review Etiquette
- **Be Kind**: Criticize code, not people
- **Be Specific**: Explain why something should change
- **Ask Questions**: "Have you considered...?" vs "This is wrong"
- **Suggest Solutions**: Don't just point out problems
- **Acknowledge Good Work**: Positive feedback matters

## Error Handling

### Error Handling Strategy
```javascript
// GOOD: Specific error handling
try {
  const user = await fetchUser(userId);
  return user;
} catch (error) {
  if (error instanceof NotFoundError) {
    return null; // Valid case: user doesn't exist
  }
  if (error instanceof ValidationError) {
    throw new BadRequestError('Invalid user ID format');
  }
  // Unexpected error: log and propagate
  logger.error('Failed to fetch user', { userId, error });
  throw error;
}

// BAD: Swallowing errors
try {
  const user = await fetchUser(userId);
  return user;
} catch (error) {
  return null; // Lost all error information!
}
```

### Error Types
- **Expected Errors**: Handle gracefully (validation, not found)
- **Unexpected Errors**: Log and propagate
- **Fatal Errors**: Log, alert, and fail fast
- **User Errors**: Return helpful error messages

### Async Error Handling
```javascript
// Always handle promise rejections
async function processData() {
  // GOOD: Errors propagate up
  const data = await fetchData();
  return transform(data);
}

// BAD: Unhandled promise rejection
function processData() {
  fetchData().then(data => transform(data));
  // No error handling!
}
```

## Performance Standards

### Performance Requirements
- **Response Time**: [API: <200ms, Page Load: <2s, etc.]
- **Throughput**: [requests per second, transactions per minute]
- **Resource Usage**: [memory, CPU, database connections]
- **Scalability**: [concurrent users, data volume]

### Performance Best Practices
```javascript
// GOOD: Efficient database query
const users = await User.find({ status: 'active' })
  .select('id name email')
  .limit(20);

// BAD: Loading unnecessary data
const users = await User.find({}); // All users
const activeUsers = users.filter(u => u.status === 'active'); // Filter in memory
```

### Avoid Premature Optimization
- **Measure First**: Profile before optimizing
- **Optimize Hot Paths**: Focus on code that runs frequently
- **Readability First**: Don't sacrifice clarity for micro-optimizations
- **Document Optimizations**: Explain non-obvious performance code

### Performance Monitoring
- Monitor key metrics in production
- Set up alerts for performance degradation
- Regular performance testing
- Track performance over time

## Logging Standards

### Log Levels
- **ERROR**: Something failed, needs attention
- **WARN**: Something unexpected, but handled
- **INFO**: Important business events
- **DEBUG**: Detailed diagnostic information
- **TRACE**: Very detailed, usually disabled

### What to Log
```javascript
// GOOD: Structured, contextual logging
logger.info('User registered', {
  userId: user.id,
  email: user.email,
  source: 'web',
  timestamp: new Date()
});

logger.error('Payment processing failed', {
  orderId: order.id,
  userId: user.id,
  amount: order.total,
  error: error.message,
  stack: error.stack
});

// BAD: Unstructured, missing context
logger.info('User registered');
logger.error('Error: ' + error);
```

### What NOT to Log
- **Passwords**: Never log passwords or tokens
- **PII**: Be careful with personal information
- **Secrets**: API keys, credentials
- **Excessive Data**: Don't log huge payloads
- **In Loops**: Avoid logging in tight loops

### Log Management
- **Centralized Logging**: Aggregate logs from all services
- **Structured Logs**: Use JSON for machine-readable logs
- **Correlation IDs**: Track requests across services
- **Retention Policy**: Define how long to keep logs
- **Log Rotation**: Prevent disk space issues

## Code Organization

### File Organization
```
src/
  components/        # UI components
    Button/
      Button.tsx
      Button.test.tsx
      Button.styles.ts
      index.ts        # Barrel export
  services/          # Business logic
  utils/             # Utility functions
  types/             # Type definitions
  constants/         # Constants and config
  hooks/             # Custom hooks
```

### Module Design
- **Single Responsibility**: Each module does one thing well
- **Loose Coupling**: Minimize dependencies between modules
- **High Cohesion**: Related functionality together
- **Clear Interfaces**: Well-defined public APIs
- **Information Hiding**: Implementation details private

### Function Design
```javascript
// GOOD: Small, focused function
function calculateTotal(items) {
  return items.reduce((sum, item) => sum + item.price, 0);
}

function applyDiscount(total, discountPercent) {
  return total * (1 - discountPercent / 100);
}

// BAD: Doing too much
function processOrder(items, user, discountCode) {
  // Calculate total
  let total = 0;
  for (const item of items) {
    total += item.price;
  }

  // Apply discount
  if (discountCode) {
    const discount = lookupDiscount(discountCode);
    total = total * (1 - discount / 100);
  }

  // Check inventory
  for (const item of items) {
    if (!checkInventory(item)) {
      throw new Error('Out of stock');
    }
  }

  // Process payment
  // ... 50 more lines
}
```

### Function Length
- **Guideline**: Functions should be <50 lines
- **Ideal**: Functions do one thing, often <20 lines
- **Exception**: Complex algorithms may be longer if well-commented

## Naming Conventions

### Variables
```javascript
// GOOD: Descriptive names
const activeUserCount = users.filter(u => u.isActive).length;
const maxRetryAttempts = 3;
const isValidEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);

// BAD: Unclear names
const x = users.filter(u => u.isActive).length; // What is x?
const num = 3; // What number?
const flag = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email); // What flag?
```

### Functions
```javascript
// GOOD: Verb + noun, clear purpose
function getUserById(id) { }
function calculateTotalPrice(items) { }
function isValidEmail(email) { }
function hasPermission(user, resource) { }

// BAD: Unclear or misleading
function user(id) { } // Get? Create? Update?
function calc(items) { } // Calculate what?
function check(email) { } // Check what? Returns what?
```

### Classes
```javascript
// GOOD: Noun, describes what it is
class UserRepository { }
class PaymentProcessor { }
class EmailValidator { }

// BAD: Vague or too generic
class Manager { } // Manages what?
class Helper { } // Helps with what?
class Utils { } // Collection of unrelated functions
```

### Constants
```javascript
// GOOD: Descriptive constants
const MAX_LOGIN_ATTEMPTS = 3;
const DEFAULT_TIMEOUT_MS = 5000;
const API_BASE_URL = 'https://api.example.com';

// BAD: Magic numbers in code
if (attempts > 3) { } // What does 3 represent?
setTimeout(callback, 5000); // Why 5000?
```

## Code Smells to Avoid

### Common Code Smells
- **Long Functions**: Break into smaller functions
- **Large Classes**: Split into multiple classes
- **Long Parameter Lists**: Use objects or builder pattern
- **Duplicated Code**: Extract to shared function
- **Dead Code**: Remove unused code
- **Comments Explaining Code**: Refactor code to be self-explanatory
- **Nested Conditionals**: Simplify logic or extract functions
- **Magic Numbers**: Use named constants

### Refactoring Examples
```javascript
// BEFORE: Nested conditionals
function processUser(user) {
  if (user) {
    if (user.isActive) {
      if (user.hasPermission('admin')) {
        // Do something
      }
    }
  }
}

// AFTER: Early returns
function processUser(user) {
  if (!user) return;
  if (!user.isActive) return;
  if (!user.hasPermission('admin')) return;

  // Do something
}

// BEFORE: Magic numbers
function retry(fn) {
  for (let i = 0; i < 3; i++) {
    try {
      return fn();
    } catch (error) {
      if (i === 2) throw error;
      wait(1000 * Math.pow(2, i));
    }
  }
}

// AFTER: Named constants
const MAX_RETRIES = 3;
const BASE_DELAY_MS = 1000;

function retry(fn) {
  for (let attempt = 0; attempt < MAX_RETRIES; attempt++) {
    try {
      return fn();
    } catch (error) {
      const isLastAttempt = attempt === MAX_RETRIES - 1;
      if (isLastAttempt) throw error;

      const delay = BASE_DELAY_MS * Math.pow(2, attempt);
      wait(delay);
    }
  }
}
```

## Technical Debt

### Managing Technical Debt
- **Document Debt**: Use TODO/FIXME comments with context
- **Track Debt**: Maintain list of known technical debt
- **Plan Paydown**: Schedule time to address debt
- **Prevent Accumulation**: Don't let debt grow unchecked

### TODO/FIXME Format
```javascript
// GOOD: Actionable with context
// TODO(username): Refactor to use async/await instead of callbacks
// Blocked by: Need to upgrade Node to v14+
// Ticket: PROJ-123

// FIXME(username): Memory leak when processing large files
// Temporary workaround: Process in chunks
// Need to investigate streaming approach

// BAD: Vague or outdated
// TODO: fix this
// FIXME: broken
```

## Code Metrics

### Metrics to Track
- **Code Coverage**: [target: 80%+]
- **Cyclomatic Complexity**: [target: <10 per function]
- **Code Churn**: [high churn = unstable code]
- **Bug Rate**: [bugs per lines of code]
- **Code Review Time**: [time to review and merge]

### Complexity Example
```javascript
// High complexity (5 branches)
function processStatus(status) {
  if (status === 'pending') return 'Processing';
  else if (status === 'approved') return 'Completed';
  else if (status === 'rejected') return 'Failed';
  else if (status === 'cancelled') return 'Cancelled';
  else return 'Unknown';
}

// Lower complexity (1 branch, more maintainable)
const STATUS_MAP = {
  pending: 'Processing',
  approved: 'Completed',
  rejected: 'Failed',
  cancelled: 'Cancelled'
};

function processStatus(status) {
  return STATUS_MAP[status] || 'Unknown';
}
```

## Continuous Improvement

### Code Quality Tools
- **Linter**: [ESLint, Pylint, golangci-lint]
- **Formatter**: [Prettier, Black, gofmt]
- **Type Checker**: [TypeScript, mypy, go vet]
- **Static Analysis**: [SonarQube, CodeClimate]
- **Security Scanner**: [Snyk, npm audit]

### Quality Gates
```yaml
# CI/CD quality gates
- run: npm run lint
- run: npm run type-check
- run: npm test
- run: npm run test:coverage
  # Fail if coverage < 80%
- run: npm audit --audit-level=moderate
  # Fail on moderate+ vulnerabilities
```

## Example Customization

```markdown
## This Project Quality Standards
- ESLint + Prettier for code formatting (enforced by pre-commit hook)
- TypeScript strict mode enabled
- Minimum 85% test coverage for new code
- Maximum cyclomatic complexity: 10 per function
- Maximum function length: 50 lines (exceptions allowed with comment)
- All public APIs must have JSDoc comments
- Sonarcode analysis on every PR (no code smells allowed)
- Code review required from 2 team members
- All errors logged with structured logging (Winston)
- Performance budget: API responses <200ms p95
- Security audit quarterly with penetration testing
- Technical debt reviewed and prioritized monthly
```

## Tips
- Quality is everyone's responsibility
- Automate quality checks (linting, testing, formatting)
- Make quality part of definition of done
- Review and update standards regularly
- Lead by example: write high-quality code yourself
- Balance quality with pragmatism: perfect is the enemy of good
- Celebrate improvements in code quality
