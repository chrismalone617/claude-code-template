# Testing Requirements

<!--
This file defines testing standards and requirements for this project.
These rules ensure consistent test coverage and quality across the codebase.
-->

## Testing Strategy

### Test Types Required
- [ ] **Unit Tests**: Test individual functions and components in isolation
- [ ] **Integration Tests**: Test interaction between modules/services
- [ ] **End-to-End Tests**: Test complete user workflows
- [ ] **API Tests**: Test API endpoints and contracts
- [ ] **Performance Tests**: Test for performance regressions
- [ ] **Security Tests**: Test for common vulnerabilities

### Coverage Requirements
- **Minimum Coverage**: [e.g., 80% overall, 90% for critical paths]
- **Required Coverage**: [e.g., all public APIs, all business logic, all UI components]
- **Exemptions**: [e.g., generated code, third-party integrations, trivial getters/setters]

## Testing Framework and Tools

### Frameworks
- **Unit Testing**: [Jest / Vitest / pytest / go test / etc.]
- **Integration Testing**: [same as unit / separate framework]
- **E2E Testing**: [Playwright / Cypress / Selenium / etc.]
- **API Testing**: [Supertest / requests / httptest / etc.]

### Utilities
- **Mocking**: [jest.mock / sinon / unittest.mock]
- **Fixtures**: [factory pattern / fixtures library / custom]
- **Test Data**: [faker / custom generators / snapshots]

## Test Organization

### File Structure
```
src/
  components/
    Button.tsx
    Button.test.tsx          # Unit tests alongside source
  services/
    api.ts
    api.test.ts
  __tests__/
    integration/            # Integration tests
    e2e/                   # End-to-end tests
```

### Naming Conventions
- **Test Files**: [*.test.ts / *.spec.ts / *_test.go]
- **Test Suites**: [describe() / suite / grouped by feature]
- **Test Cases**: [it() / test() / TestFunctionName]

## Writing Tests

### Test Structure
```javascript
// Arrange-Act-Assert pattern
describe('UserService', () => {
  it('should create a new user with valid data', () => {
    // Arrange: Set up test data and dependencies
    const userData = { name: 'Test User', email: 'test@example.com' };

    // Act: Execute the function being tested
    const result = userService.create(userData);

    // Assert: Verify the outcome
    expect(result.id).toBeDefined();
    expect(result.name).toBe(userData.name);
  });
});
```

### Test Quality Standards
- **Single Responsibility**: Each test should verify one behavior
- **Independence**: Tests should not depend on each other
- **Repeatability**: Tests should produce the same result every time
- **Fast Execution**: Unit tests should run in milliseconds
- **Clear Names**: Test names should describe the scenario and expected outcome
- **No Logic**: Tests should be simple and not contain conditional logic

### What to Test
- **Happy Paths**: Normal, expected use cases
- **Edge Cases**: Boundary conditions, empty inputs, null values
- **Error Cases**: Invalid inputs, error conditions, exceptions
- **Integration Points**: Interactions with external services, databases, APIs

### What Not to Test
- **Third-Party Code**: Don't test library/framework internals
- **Trivial Code**: Simple getters/setters without logic
- **Private Methods**: Test through public interfaces
- **Implementation Details**: Test behavior, not implementation

## Mocking Strategy

### When to Mock
- **External Services**: APIs, databases, file systems
- **Slow Operations**: Network calls, heavy computations
- **Non-Deterministic**: Random values, dates, timers
- **Side Effects**: Logging, metrics, notifications

### When to Use Real Implementations
- **Unit Under Test**: Always use the real implementation
- **Pure Functions**: Simple utilities without dependencies
- **Test Doubles**: Lightweight in-memory implementations

### Mock Examples
```javascript
// Mock external API
jest.mock('./api', () => ({
  fetchUser: jest.fn().mockResolvedValue({ id: 1, name: 'Test' })
}));

// Mock with different implementations per test
beforeEach(() => {
  apiMock.fetchUser.mockClear();
});

it('handles API error', async () => {
  apiMock.fetchUser.mockRejectedValueOnce(new Error('Network error'));
  // Test error handling
});
```

## Test Data Management

### Approach
- **Fixtures**: [shared test data files / factories / inline]
- **Factories**: [use factory pattern for creating test objects]
- **Randomization**: [faker for realistic data / controlled random seeds]

### Database Tests
- **Strategy**: [in-memory DB / test database / transactions with rollback]
- **Seeding**: [seed before each test / shared seed / isolated data]
- **Cleanup**: [rollback / truncate / fresh DB per test]

## Continuous Integration

### CI Requirements
- **All Tests Must Pass**: No merging with failing tests
- **Coverage Checks**: Fail if coverage drops below threshold
- **Performance**: Fail if tests take longer than [X minutes]

### Pre-Commit Hooks
- [ ] Run tests on changed files
- [ ] Run linter
- [ ] Check coverage on new code

### Pre-Push Hooks
- [ ] Run full test suite
- [ ] Verify coverage thresholds

## Running Tests

### Commands
```bash
# Run all tests
npm test

# Run with coverage
npm run test:coverage

# Run specific test file
npm test -- path/to/test.test.ts

# Run in watch mode
npm test -- --watch

# Run E2E tests
npm run test:e2e
```

### Development Workflow
1. Write failing test first (TDD)
2. Implement minimum code to pass
3. Refactor while keeping tests green
4. Verify coverage for new code

## Performance Testing

### Requirements
- **Critical Paths**: [endpoints/functions that must meet SLAs]
- **Benchmarks**: [acceptable response times, throughput]
- **Load Testing**: [concurrent users, requests per second]

### Tools
- **Benchmarking**: [benchmark.js / go benchmark / pytest-benchmark]
- **Load Testing**: [k6 / Artillery / JMeter]

## Example Customization

```markdown
## This Project Requirements
- Jest for all unit and integration tests
- Playwright for E2E tests
- Minimum 85% code coverage for new code
- All public APIs must have unit tests
- Critical user flows must have E2E tests
- Tests run automatically on every commit via GitHub Actions
- Use React Testing Library for component tests
- Mock all external API calls in tests
- Use MSW for API mocking in integration tests
- Test naming: describe what the code does, not how
- Keep tests fast: unit tests <5s total, integration <30s
```

## Tips
- Write tests as you code, not after
- Failing tests are better than no tests
- Test the behavior, not the implementation
- Refactor tests just like production code
- Use descriptive test names that explain the scenario
- Review test coverage reports regularly
- Delete obsolete tests
