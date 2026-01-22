# Backend Rules Example

<!--
This is an example of backend-specific rules that apply to API and server code.
-->

---
name: backend-rules
paths:
  - "src/api/**"
  - "src/services/**"
  - "src/controllers/**"
  - "src/models/**"
priority: 10
---

# Backend Development Rules

## API Design

### RESTful Conventions
Follow REST principles for API endpoints.

```typescript
// Resource naming: plural nouns
GET    /api/users           // List users
GET    /api/users/:id       // Get user
POST   /api/users           // Create user
PUT    /api/users/:id       // Update user (full)
PATCH  /api/users/:id       // Update user (partial)
DELETE /api/users/:id       // Delete user

// Nested resources
GET    /api/users/:id/posts         // Get user's posts
POST   /api/users/:id/posts         // Create post for user
GET    /api/posts/:id/comments      // Get post's comments
```

### HTTP Status Codes
Use appropriate status codes.

```typescript
// Success
200 OK                    // Successful GET, PUT, PATCH
201 Created               // Successful POST
204 No Content            // Successful DELETE

// Client Errors
400 Bad Request           // Invalid request data
401 Unauthorized          // Authentication required
403 Forbidden             // Authenticated but not authorized
404 Not Found             // Resource doesn't exist
409 Conflict              // Conflict with current state
422 Unprocessable Entity  // Validation errors

// Server Errors
500 Internal Server Error // Unexpected server error
503 Service Unavailable   // Temporary unavailability
```

### Request/Response Format

```typescript
// Request body validation
interface CreateUserRequest {
  email: string;
  password: string;
  name: string;
}

// Success response
interface SuccessResponse<T> {
  data: T;
  message?: string;
}

// Error response
interface ErrorResponse {
  error: {
    message: string;
    code: string;
    details?: Record<string, string[]>; // Validation errors
  };
}

// Example endpoint
app.post('/api/users', async (req, res) => {
  try {
    const userData: CreateUserRequest = req.body;

    // Validation
    const errors = validateUser(userData);
    if (errors) {
      return res.status(422).json({
        error: {
          message: 'Validation failed',
          code: 'VALIDATION_ERROR',
          details: errors
        }
      });
    }

    const user = await createUser(userData);

    return res.status(201).json({
      data: user,
      message: 'User created successfully'
    });
  } catch (error) {
    return res.status(500).json({
      error: {
        message: 'An error occurred',
        code: 'INTERNAL_ERROR'
      }
    });
  }
});
```

## Database Access

### Use ORMs/Query Builders
Always use parameterized queries via ORM or query builder.

```typescript
// GOOD - Using Prisma
const user = await prisma.user.findUnique({
  where: { id: userId }
});

// GOOD - Using query builder
const user = await db('users')
  .where({ id: userId })
  .first();

// BAD - Raw SQL with string interpolation (SQL injection!)
const user = await db.raw(`SELECT * FROM users WHERE id = ${userId}`);

// GOOD - Raw SQL with parameters (if necessary)
const user = await db.raw('SELECT * FROM users WHERE id = ?', [userId]);
```

### Transaction Management

```typescript
// Use transactions for multi-step operations
async function transferFunds(fromId: string, toId: string, amount: number) {
  return await prisma.$transaction(async (tx) => {
    // Deduct from sender
    await tx.account.update({
      where: { id: fromId },
      data: { balance: { decrement: amount } }
    });

    // Add to receiver
    await tx.account.update({
      where: { id: toId },
      data: { balance: { increment: amount } }
    });

    // Create transaction record
    return await tx.transaction.create({
      data: {
        fromId,
        toId,
        amount,
        type: 'TRANSFER'
      }
    });
  });
}
```

### Query Optimization

```typescript
// BAD - N+1 query problem
const users = await prisma.user.findMany();
for (const user of users) {
  user.posts = await prisma.post.findMany({
    where: { userId: user.id }
  });
}

// GOOD - Use includes/joins
const users = await prisma.user.findMany({
  include: {
    posts: true
  }
});

// GOOD - Select only needed fields
const users = await prisma.user.findMany({
  select: {
    id: true,
    email: true,
    name: true
  }
});
```

## Authentication & Authorization

### Password Hashing
Always hash passwords with bcrypt or similar.

```typescript
import bcrypt from 'bcrypt';

// Hashing password
async function hashPassword(password: string): Promise<string> {
  const saltRounds = 12;
  return await bcrypt.hash(password, saltRounds);
}

// Verifying password
async function verifyPassword(password: string, hash: string): Promise<boolean> {
  return await bcrypt.compare(password, hash);
}

// NEVER store plain text passwords
// BAD
await prisma.user.create({
  data: {
    email: 'user@example.com',
    password: 'plain-text-password' // NEVER DO THIS
  }
});

// GOOD
await prisma.user.create({
  data: {
    email: 'user@example.com',
    passwordHash: await hashPassword(password)
  }
});
```

### JWT Authentication

```typescript
import jwt from 'jsonwebtoken';

interface TokenPayload {
  userId: string;
  email: string;
}

// Generate token
function generateToken(payload: TokenPayload): string {
  return jwt.sign(payload, process.env.JWT_SECRET!, {
    expiresIn: '1h'
  });
}

// Verify token middleware
function authMiddleware(req: Request, res: Response, next: NextFunction) {
  const token = req.headers.authorization?.split(' ')[1];

  if (!token) {
    return res.status(401).json({
      error: { message: 'Authentication required', code: 'UNAUTHORIZED' }
    });
  }

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET!) as TokenPayload;
    req.user = payload;
    next();
  } catch (error) {
    return res.status(401).json({
      error: { message: 'Invalid token', code: 'INVALID_TOKEN' }
    });
  }
}
```

### Authorization Checks

```typescript
// Check permissions before operations
async function deletePost(userId: string, postId: string) {
  const post = await prisma.post.findUnique({
    where: { id: postId }
  });

  if (!post) {
    throw new NotFoundError('Post not found');
  }

  // Authorization check
  if (post.authorId !== userId) {
    throw new ForbiddenError('You do not have permission to delete this post');
  }

  return await prisma.post.delete({
    where: { id: postId }
  });
}
```

## Error Handling

### Custom Error Classes

```typescript
// Define custom error types
export class AppError extends Error {
  constructor(
    public message: string,
    public statusCode: number,
    public code: string
  ) {
    super(message);
    this.name = this.constructor.name;
    Error.captureStackTrace(this, this.constructor);
  }
}

export class NotFoundError extends AppError {
  constructor(message: string = 'Resource not found') {
    super(message, 404, 'NOT_FOUND');
  }
}

export class ValidationError extends AppError {
  constructor(message: string = 'Validation failed', public details?: any) {
    super(message, 422, 'VALIDATION_ERROR');
  }
}

export class UnauthorizedError extends AppError {
  constructor(message: string = 'Unauthorized') {
    super(message, 401, 'UNAUTHORIZED');
  }
}

export class ForbiddenError extends AppError {
  constructor(message: string = 'Forbidden') {
    super(message, 403, 'FORBIDDEN');
  }
}
```

### Error Handling Middleware

```typescript
// Global error handler (Express)
function errorHandler(
  error: Error,
  req: Request,
  res: Response,
  next: NextFunction
) {
  // Log error
  logger.error('Request error', {
    error: error.message,
    stack: error.stack,
    path: req.path,
    method: req.method,
    userId: req.user?.id
  });

  // Handle known errors
  if (error instanceof AppError) {
    return res.status(error.statusCode).json({
      error: {
        message: error.message,
        code: error.code,
        details: error instanceof ValidationError ? error.details : undefined
      }
    });
  }

  // Handle unexpected errors
  return res.status(500).json({
    error: {
      message: 'An unexpected error occurred',
      code: 'INTERNAL_ERROR'
    }
  });
}

app.use(errorHandler);
```

## Input Validation

### Validate All Input
Use validation library like Zod or Joi.

```typescript
import { z } from 'zod';

// Define schema
const createUserSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
  name: z.string().min(1, 'Name is required'),
  age: z.number().int().min(18, 'Must be at least 18 years old').optional()
});

// Validation middleware
function validate(schema: z.ZodSchema) {
  return (req: Request, res: Response, next: NextFunction) => {
    try {
      req.body = schema.parse(req.body);
      next();
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(422).json({
          error: {
            message: 'Validation failed',
            code: 'VALIDATION_ERROR',
            details: error.errors
          }
        });
      }
      next(error);
    }
  };
}

// Use in route
app.post('/api/users', validate(createUserSchema), async (req, res) => {
  // req.body is now validated and typed
  const user = await createUser(req.body);
  res.status(201).json({ data: user });
});
```

## Logging

### Structured Logging

```typescript
import winston from 'winston';

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});

// Log with context
logger.info('User created', {
  userId: user.id,
  email: user.email,
  timestamp: new Date().toISOString()
});

logger.error('Database connection failed', {
  error: error.message,
  stack: error.stack
});
```

### Request Logging

```typescript
// Log all requests
app.use((req, res, next) => {
  const start = Date.now();

  res.on('finish', () => {
    const duration = Date.now() - start;
    logger.info('Request completed', {
      method: req.method,
      path: req.path,
      statusCode: res.statusCode,
      duration,
      userId: req.user?.id
    });
  });

  next();
});
```

## Testing

### Unit Tests for Services

```typescript
import { describe, it, expect, beforeEach } from 'vitest';
import { createUser, getUserById } from './userService';

describe('UserService', () => {
  beforeEach(async () => {
    // Clean up database
    await prisma.user.deleteMany();
  });

  it('creates a new user', async () => {
    const userData = {
      email: 'test@example.com',
      password: 'password123',
      name: 'Test User'
    };

    const user = await createUser(userData);

    expect(user.email).toBe(userData.email);
    expect(user.name).toBe(userData.name);
    expect(user.passwordHash).toBeDefined();
    expect(user.passwordHash).not.toBe(userData.password);
  });

  it('throws error for duplicate email', async () => {
    const userData = {
      email: 'test@example.com',
      password: 'password123',
      name: 'Test User'
    };

    await createUser(userData);

    await expect(createUser(userData)).rejects.toThrow('Email already exists');
  });
});
```

### Integration Tests for APIs

```typescript
import request from 'supertest';
import { app } from './app';

describe('POST /api/users', () => {
  it('creates a new user', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User'
      });

    expect(response.status).toBe(201);
    expect(response.body.data).toMatchObject({
      email: 'test@example.com',
      name: 'Test User'
    });
    expect(response.body.data.passwordHash).toBeUndefined(); // Don't return hash
  });

  it('returns 422 for invalid data', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({
        email: 'invalid-email',
        password: 'short'
      });

    expect(response.status).toBe(422);
    expect(response.body.error.code).toBe('VALIDATION_ERROR');
  });
});
```

## Performance

### Caching

```typescript
import Redis from 'ioredis';

const redis = new Redis(process.env.REDIS_URL);

async function getUserWithCache(userId: string) {
  // Try cache first
  const cached = await redis.get(`user:${userId}`);
  if (cached) {
    return JSON.parse(cached);
  }

  // Fetch from database
  const user = await prisma.user.findUnique({
    where: { id: userId }
  });

  // Store in cache (24 hours)
  if (user) {
    await redis.setex(`user:${userId}`, 86400, JSON.stringify(user));
  }

  return user;
}

// Invalidate cache on update
async function updateUser(userId: string, data: UpdateUserData) {
  const user = await prisma.user.update({
    where: { id: userId },
    data
  });

  // Invalidate cache
  await redis.del(`user:${userId}`);

  return user;
}
```

### Rate Limiting

```typescript
import rateLimit from 'express-rate-limit';

const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per windowMs
  message: {
    error: {
      message: 'Too many requests, please try again later',
      code: 'RATE_LIMIT_EXCEEDED'
    }
  }
});

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5, // Stricter limit for auth endpoints
  skipSuccessfulRequests: true // Don't count successful logins
});

app.use('/api/', apiLimiter);
app.use('/api/auth/', authLimiter);
```
