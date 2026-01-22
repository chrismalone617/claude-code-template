# Frontend Rules Example

<!--
This is an example of frontend-specific rules that apply to certain file paths.
You can scope rules to specific directories using YAML frontmatter.
-->

---
name: frontend-rules
paths:
  - "src/components/**"
  - "src/pages/**"
  - "src/hooks/**"
priority: 10
---

# React/Frontend Development Rules

## Component Structure

### Functional Components Only
Always use functional components with hooks. Class components are not allowed.

```tsx
// GOOD
const Button: React.FC<ButtonProps> = ({ children, onClick }) => {
  return <button onClick={onClick}>{children}</button>;
};

// BAD - No class components
class Button extends React.Component {
  render() {
    return <button>{this.props.children}</button>;
  }
}
```

### Component File Organization
Each component should have its own directory with related files:

```
Button/
  ├── Button.tsx          # Component implementation
  ├── Button.test.tsx     # Tests
  ├── Button.stories.tsx  # Storybook stories (if using Storybook)
  ├── Button.styles.ts    # Styles (if not using CSS modules)
  └── index.ts           # Barrel export
```

## Hooks Rules

### Custom Hooks
- Always prefix with `use` (e.g., `useUserData`, `useAuth`)
- Place in `src/hooks/` directory
- Include comprehensive tests
- Document parameters and return values

```tsx
/**
 * Fetches and manages user data with automatic refetching.
 * @param userId - The ID of the user to fetch
 * @returns User data, loading state, and error state
 */
export function useUserData(userId: string) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    // Implementation
  }, [userId]);

  return { user, loading, error };
}
```

### Hook Dependencies
Always include all dependencies in useEffect/useCallback/useMemo arrays. Let ESLint guide you.

```tsx
// GOOD
useEffect(() => {
  fetchData(userId);
}, [userId]); // userId included

// BAD
useEffect(() => {
  fetchData(userId);
}, []); // Missing dependency
```

## TypeScript Types

### Props Types
Always define explicit prop types. Use interfaces for component props.

```tsx
interface ButtonProps {
  /** Button text */
  children: React.ReactNode;
  /** Click handler */
  onClick?: () => void;
  /** Button variant */
  variant?: 'primary' | 'secondary' | 'danger';
  /** Disabled state */
  disabled?: boolean;
}

const Button: React.FC<ButtonProps> = ({ children, onClick, variant = 'primary', disabled = false }) => {
  // Implementation
};
```

### Avoid `any`
Never use `any` type. Use `unknown` if type is truly unknown, then narrow it.

```tsx
// BAD
const handleData = (data: any) => {
  console.log(data.value);
};

// GOOD
const handleData = (data: unknown) => {
  if (isValidData(data)) {
    console.log(data.value);
  }
};
```

## State Management

### useState for Local State
Use `useState` for component-local state.

```tsx
const [count, setCount] = useState(0);
const [user, setUser] = useState<User | null>(null);
```

### useReducer for Complex State
Use `useReducer` when state logic is complex or involves multiple sub-values.

```tsx
type State = {
  loading: boolean;
  data: Data | null;
  error: Error | null;
};

type Action =
  | { type: 'FETCH_START' }
  | { type: 'FETCH_SUCCESS'; payload: Data }
  | { type: 'FETCH_ERROR'; payload: Error };

const reducer = (state: State, action: Action): State => {
  switch (action.type) {
    case 'FETCH_START':
      return { ...state, loading: true };
    case 'FETCH_SUCCESS':
      return { loading: false, data: action.payload, error: null };
    case 'FETCH_ERROR':
      return { loading: false, data: null, error: action.payload };
  }
};
```

### Context for Global State
Use Context for truly global state (theme, auth, etc.). Don't overuse.

```tsx
const AuthContext = createContext<AuthContextValue | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);

  const value = { user, setUser };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider');
  }
  return context;
};
```

## Styling

### Use CSS Modules or Styled Components
Choose one approach and stick with it consistently.

```tsx
// CSS Modules
import styles from './Button.module.css';

const Button = () => <button className={styles.button}>Click me</button>;

// Or Styled Components
import styled from 'styled-components';

const StyledButton = styled.button`
  padding: 10px 20px;
  background: blue;
`;
```

### No Inline Styles (except dynamic values)
Avoid inline styles unless the value is truly dynamic.

```tsx
// BAD
<div style={{ padding: '20px', margin: '10px' }}>Content</div>

// GOOD
<div className={styles.container}>Content</div>

// GOOD (dynamic value)
<div style={{ width: `${progress}%` }}>Content</div>
```

## Performance

### Memoization
Use `React.memo` for expensive components that render often with same props.

```tsx
const ExpensiveComponent = React.memo<ExpensiveComponentProps>(({ data }) => {
  // Expensive rendering logic
  return <div>{/* ... */}</div>;
});
```

### useCallback and useMemo
Use when passing callbacks to memoized child components or computing expensive values.

```tsx
const ExpensiveComponent = () => {
  const handleClick = useCallback(() => {
    // Handler logic
  }, [dependencies]);

  const expensiveValue = useMemo(() => {
    return computeExpensiveValue(data);
  }, [data]);

  return <ChildComponent onClick={handleClick} value={expensiveValue} />;
};
```

## Testing

### Test Component Behavior
Test what the component does, not how it does it.

```tsx
import { render, screen, fireEvent } from '@testing-library/react';

describe('Button', () => {
  it('calls onClick when clicked', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click me</Button>);

    fireEvent.click(screen.getByText('Click me'));

    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('shows loading state', () => {
    render(<Button loading>Click me</Button>);

    expect(screen.getByRole('button')).toBeDisabled();
    expect(screen.getByText('Loading...')).toBeInTheDocument();
  });
});
```

## Accessibility

### Semantic HTML
Use semantic HTML elements whenever possible.

```tsx
// GOOD
<button onClick={handleClick}>Click me</button>
<nav><ul><li><a href="/home">Home</a></li></ul></nav>

// BAD
<div onClick={handleClick}>Click me</div>
<div><div><div><span>Home</span></div></div></div>
```

### ARIA Labels
Add ARIA labels for screen readers when semantic HTML isn't enough.

```tsx
<button aria-label="Close dialog" onClick={onClose}>
  <XIcon />
</button>

<input
  type="text"
  aria-describedby="email-help"
  placeholder="Email"
/>
<span id="email-help">We'll never share your email</span>
```

### Keyboard Navigation
Ensure all interactive elements are keyboard accessible.

```tsx
const Dropdown = () => {
  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Escape') {
      closeDropdown();
    }
  };

  return <div onKeyDown={handleKeyDown} tabIndex={0}>{/* ... */}</div>;
};
```

## Error Boundaries

Use error boundaries to catch rendering errors.

```tsx
class ErrorBoundary extends React.Component<
  { children: React.ReactNode },
  { hasError: boolean }
> {
  state = { hasError: false };

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('Error caught by boundary:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return <h1>Something went wrong.</h1>;
    }

    return this.props.children;
  }
}
```

## Import Organization

Organize imports in this order:
1. React and third-party libraries
2. Internal components
3. Utilities and helpers
4. Types
5. Styles

```tsx
// External
import React, { useState, useEffect } from 'react';
import { useQuery } from 'react-query';

// Internal components
import { Button } from '@/components/Button';
import { Card } from '@/components/Card';

// Utilities
import { formatDate } from '@/utils/date';
import { api } from '@/lib/api';

// Types
import type { User } from '@/types/user';

// Styles
import styles from './UserProfile.module.css';
```
