# Coding Style Preferences

<!--
This file defines your personal coding style and preferences.
Claude will follow these guidelines when writing or modifying code.
-->

## Language Preferences
- **Primary Languages**: [JavaScript/TypeScript, Python, Go, etc.]
- **Framework Preferences**: [React, Vue, Django, Express, etc.]
- **Avoid**: [specific languages, frameworks, or patterns to avoid]

## Code Structure

### Formatting
- **Indentation**: [2 spaces / 4 spaces / tabs]
- **Line Length**: [80 / 100 / 120 characters]
- **Quotes**: [single / double / template literals preferred]
- **Semicolons**: [always / never / auto]
- **Trailing Commas**: [always / never / multiline]

### Brace Style
```javascript
// K&R style
function example() {
  if (condition) {
    // code
  }
}

// Allman style
function example()
{
  if (condition)
  {
    // code
  }
}
```

## Naming Conventions

### Variables and Functions
- **Variables**: [camelCase / snake_case / PascalCase]
- **Constants**: [UPPER_CASE / camelCase with const]
- **Private Members**: [_prefix / #private / suffix_]
- **Boolean Variables**: [isActive, hasPermission / active, permission]

### Files and Directories
- **Component Files**: [PascalCase.tsx / kebab-case.tsx / index.tsx]
- **Utility Files**: [camelCase.ts / kebab-case.ts / snake_case.ts]
- **Test Files**: [*.test.ts / *.spec.ts / *_test.ts]

## Code Organization

### File Structure
- **Imports Order**: [built-in, external, internal, relative]
- **Export Style**: [named exports / default exports / mixed]
- **File Length**: [max lines before suggesting split]

### Function Design
- **Size**: [small focused functions / larger comprehensive functions]
- **Parameters**: [max parameter count before suggesting object]
- **Return Style**: [early returns / single return point]

### Error Handling
- **Style**: [try-catch / error returns / throw exceptions]
- **Async Errors**: [async/await with try-catch / .catch() / error boundaries]
- **Validation**: [at boundaries only / defensive everywhere]

## Comments and Documentation

### Code Comments
- **Frequency**: [minimal / standard / extensive]
- **Style**: [explain why, not what / document public APIs / inline for complex logic]
- **TODOs**: [TODO: / FIXME: / custom tags]

### Documentation Comments
- **Functions**: [JSDoc / docstrings / minimal]
- **Classes**: [full documentation / public methods only / minimal]
- **Types**: [document complex types / let types self-document]

## Patterns and Best Practices

### Design Patterns
- **Preferred**: [composition over inheritance / functional programming / OOP]
- **State Management**: [Redux / Context / Zustand / MobX]
- **Async Patterns**: [async/await / promises / callbacks]

### TypeScript Specific
- **Type Style**: [interfaces / types / mixed]
- **Strictness**: [strict mode / permissive / custom]
- **Any Usage**: [never / sparingly / when necessary]
- **Generics**: [use liberally / only when needed]

### React Specific
- **Component Style**: [functional / class / hooks]
- **Props**: [destructure / use props object]
- **State**: [useState / useReducer / custom hooks]
- **Effects**: [useEffect / custom hooks / libraries]

### Testing
- **Framework**: [Jest / Vitest / Mocha / pytest]
- **Style**: [describe/it / test() / custom]
- **Coverage**: [aim for X% / critical paths only]
- **Mocking**: [prefer real implementations / mock external / mock everything]

## Code Quality

### Optimization
- **Premature Optimization**: [avoid / optimize as you go / measure first]
- **Performance**: [readability first / balanced / performance critical]
- **Bundle Size**: [very concerned / balanced / not a priority]

### Dependencies
- **External Packages**: [prefer standard library / use popular packages / minimize dependencies]
- **Version Pinning**: [exact / caret / tilde]
- **Updates**: [aggressive / conservative / security only]

## Example Customization

```markdown
## My Preferences
- TypeScript with strict mode always
- 2-space indentation, 100 character lines
- Single quotes for strings, template literals for interpolation
- Named exports preferred over default exports
- Small, focused functions (max 50 lines)
- Functional components with hooks in React
- Extensive JSDoc comments for public APIs only
- Test coverage minimum 80% for new code
- Error handling: try-catch for async, throw for invalid input
- Prefer composition and functional patterns
- Use Prettier for auto-formatting (so don't worry about minor style)
```

## Tips
- Link to your ESLint/Prettier config if you have one
- Specify any company or team style guides to follow
- Note any auto-formatting tools in use
- Be specific about preferences that matter most to you
- Update based on patterns you notice in code reviews
