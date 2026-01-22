# Security Requirements

<!--
This file defines security standards and requirements for this project.
Security is not optional - these requirements must be followed.
-->

## Security Principles

### Core Principles
- **Defense in Depth**: Multiple layers of security
- **Least Privilege**: Minimum necessary permissions
- **Fail Securely**: Default to secure state on errors
- **Never Trust Input**: Validate and sanitize all external data
- **Security by Design**: Security from the start, not bolted on

### Threat Model
- [Define your threat model: what are you protecting against?]
- [Who are the potential attackers?]
- [What are the most valuable assets?]
- [What are acceptable risks?]

## Authentication and Authorization

### Authentication Requirements
- [ ] **Strong Passwords**: Minimum 12 characters, complexity requirements
- [ ] **Multi-Factor Authentication**: Required for sensitive operations
- [ ] **Session Management**: Secure session tokens, timeout, regeneration
- [ ] **Account Lockout**: Protection against brute force attacks
- [ ] **Password Reset**: Secure password reset flow with time-limited tokens

### Password Handling
```javascript
// NEVER do this
const password = request.body.password;
db.query(`INSERT INTO users (password) VALUES ('${password}')`);

// Always hash passwords
import bcrypt from 'bcrypt';
const hashedPassword = await bcrypt.hash(password, 12);
db.query('INSERT INTO users (password_hash) VALUES ($1)', [hashedPassword]);
```

### Session Management
- **Secure Cookies**: Use `httpOnly`, `secure`, `sameSite` flags
- **Session Timeout**: Implement idle and absolute timeouts
- **Token Rotation**: Rotate tokens on privilege escalation
- **Logout**: Invalidate tokens on server side

```javascript
// Secure cookie settings
res.cookie('session', token, {
  httpOnly: true,    // Prevents XSS access
  secure: true,      // HTTPS only
  sameSite: 'strict', // CSRF protection
  maxAge: 3600000    // 1 hour
});
```

### Authorization
- **Role-Based Access Control**: Define clear roles and permissions
- **Resource-Level Authorization**: Check permissions for specific resources
- **Principle of Least Privilege**: Users get minimum required permissions
- **Regular Audits**: Review and update permissions regularly

## Data Protection

### Data Classification
- **Public**: No protection needed
- **Internal**: Basic access control
- **Confidential**: Encryption at rest and in transit
- **Sensitive/PII**: Strict access control, encryption, audit logging

### Encryption

#### In Transit
- **HTTPS/TLS Only**: No unencrypted HTTP
- **TLS 1.2+**: Disable older protocols
- **Certificate Validation**: Always validate certificates
- **HSTS Headers**: Force HTTPS

```javascript
// Express example
app.use((req, res, next) => {
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
  next();
});
```

#### At Rest
- **Sensitive Data**: Encrypt database fields containing PII
- **Secrets**: Use secret management (Vault, AWS Secrets Manager)
- **Backups**: Encrypt backup files
- **Key Management**: Rotate encryption keys regularly

### Secrets Management
```bash
# NEVER commit secrets to git
# BAD: Hardcoded in code
const apiKey = 'sk_live_abc123...';

# GOOD: Use environment variables
const apiKey = process.env.API_KEY;

# BETTER: Use secret management service
const apiKey = await secretManager.getSecret('api-key');
```

### Personal Identifiable Information (PII)
- **Minimize Collection**: Only collect necessary PII
- **Data Retention**: Delete PII when no longer needed
- **Access Logging**: Log all access to PII
- **Anonymization**: Anonymize data for analytics
- **Right to Deletion**: Implement data deletion on request

## Input Validation

### Validation Rules
- **Validate All Input**: Never trust user input
- **Whitelist Over Blacklist**: Define what's allowed, not what's forbidden
- **Type Validation**: Ensure correct data types
- **Range Validation**: Check bounds for numbers, length for strings
- **Format Validation**: Use regex or validators for specific formats

### SQL Injection Prevention
```javascript
// NEVER do this - SQL injection vulnerability
const userId = req.params.id;
db.query(`SELECT * FROM users WHERE id = ${userId}`);

// Always use parameterized queries
db.query('SELECT * FROM users WHERE id = $1', [userId]);

// Or use an ORM
User.findById(userId);
```

### Cross-Site Scripting (XSS) Prevention
```javascript
// Escape user input before rendering
import { escape } from 'lodash';
const safeUsername = escape(userInput);

// Use templating engines that auto-escape
// React, Vue, Angular auto-escape by default

// Set Content Security Policy headers
res.setHeader('Content-Security-Policy', "default-src 'self'");
```

### Command Injection Prevention
```javascript
// NEVER do this - command injection vulnerability
const filename = req.params.filename;
exec(`cat ${filename}`);

// Validate and sanitize input
const safeFilename = path.basename(filename); // Remove path traversal
if (!/^[a-zA-Z0-9._-]+$/.test(safeFilename)) {
  throw new Error('Invalid filename');
}

// Better: Use library functions instead of shell commands
fs.readFile(safeFilename, 'utf8', callback);
```

### Path Traversal Prevention
```javascript
// NEVER do this - path traversal vulnerability
const file = req.query.file;
res.sendFile(file);

// Validate path is within allowed directory
const safeFilename = path.basename(file);
const safePath = path.join(__dirname, 'uploads', safeFilename);
if (!safePath.startsWith(path.join(__dirname, 'uploads'))) {
  throw new Error('Invalid path');
}
res.sendFile(safePath);
```

## Cross-Site Request Forgery (CSRF)

### CSRF Protection
```javascript
// Use CSRF tokens for state-changing operations
import csrf from 'csurf';
app.use(csrf());

// Include token in forms
<form method="POST">
  <input type="hidden" name="_csrf" value="{{csrfToken}}">
</form>

// Or use SameSite cookie attribute
res.cookie('session', token, { sameSite: 'strict' });
```

## Security Headers

### Required Headers
```javascript
// Security headers middleware
app.use((req, res, next) => {
  // Prevent MIME type sniffing
  res.setHeader('X-Content-Type-Options', 'nosniff');

  // XSS protection
  res.setHeader('X-XSS-Protection', '1; mode=block');

  // Prevent clickjacking
  res.setHeader('X-Frame-Options', 'DENY');

  // HTTPS only
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');

  // Content Security Policy
  res.setHeader('Content-Security-Policy', "default-src 'self'");

  // Referrer policy
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');

  // Permissions policy
  res.setHeader('Permissions-Policy', 'geolocation=(), microphone=()');

  next();
});
```

## Dependency Security

### Dependency Management
- [ ] **Vulnerability Scanning**: Regular scans with `npm audit`, Snyk, or Dependabot
- [ ] **Keep Updated**: Update dependencies regularly, especially security patches
- [ ] **Pin Versions**: Use lockfiles (package-lock.json, yarn.lock)
- [ ] **Review Dependencies**: Audit new dependencies before adding
- [ ] **Minimize Dependencies**: Fewer dependencies = smaller attack surface

### Scanning Commands
```bash
# Check for vulnerabilities
npm audit

# Fix automatically (be careful)
npm audit fix

# Check with Snyk
npx snyk test

# Check for outdated packages
npm outdated
```

## API Security

### Rate Limiting
```javascript
// Prevent abuse and DoS attacks
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per windowMs
  message: 'Too many requests, please try again later.'
});

app.use('/api/', limiter);
```

### API Authentication
- **API Keys**: For service-to-service
- **OAuth2/JWT**: For user authentication
- **API Key Rotation**: Regularly rotate keys
- **Scope Limitation**: Limit API key permissions

### API Input Validation
```javascript
// Validate request schema
import Joi from 'joi';

const schema = Joi.object({
  email: Joi.string().email().required(),
  age: Joi.number().integer().min(0).max(120)
});

const { error, value } = schema.validate(req.body);
if (error) {
  return res.status(400).json({ error: error.details[0].message });
}
```

## Logging and Monitoring

### Security Logging
- **Authentication Events**: Login, logout, failed attempts
- **Authorization Failures**: Access denied events
- **Sensitive Operations**: Data access, modifications, deletions
- **Security Events**: Suspicious activity, potential attacks
- **Never Log Secrets**: Don't log passwords, tokens, API keys

### Log Content
```javascript
// Good logging
logger.info('User login successful', {
  userId: user.id,
  ip: req.ip,
  timestamp: new Date()
});

// BAD: Don't log sensitive data
logger.info('User login', {
  password: password, // NEVER log passwords
  token: token        // NEVER log tokens
});
```

### Monitoring and Alerting
- **Failed Login Attempts**: Alert on unusual patterns
- **Privilege Escalation**: Alert on role changes
- **Data Access**: Monitor access to sensitive data
- **Error Rates**: Alert on unusual error rates
- **Performance**: Monitor for DoS attacks

## Error Handling

### Secure Error Messages
```javascript
// BAD: Exposes internals
catch (error) {
  res.status(500).json({ error: error.stack });
}

// GOOD: Generic message to user, detailed log
catch (error) {
  logger.error('Database error', { error, userId: req.user.id });
  res.status(500).json({ error: 'An error occurred. Please try again.' });
}
```

### Information Disclosure
- **Production Errors**: Generic messages only
- **Stack Traces**: Never expose to users in production
- **Database Errors**: Don't expose schema or query details
- **404 vs 403**: Consider information leakage

## Security Checklist

### Before Every Release
- [ ] All dependencies updated and scanned for vulnerabilities
- [ ] Security headers configured
- [ ] HTTPS/TLS enforced
- [ ] Input validation on all user inputs
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (output escaping)
- [ ] CSRF protection enabled
- [ ] Rate limiting configured
- [ ] Authentication and authorization tested
- [ ] Secrets not hardcoded or committed
- [ ] Security logging enabled
- [ ] Error messages don't leak information
- [ ] Security tests pass

### OWASP Top 10 Coverage
- [ ] A01: Broken Access Control
- [ ] A02: Cryptographic Failures
- [ ] A03: Injection
- [ ] A04: Insecure Design
- [ ] A05: Security Misconfiguration
- [ ] A06: Vulnerable and Outdated Components
- [ ] A07: Identification and Authentication Failures
- [ ] A08: Software and Data Integrity Failures
- [ ] A09: Security Logging and Monitoring Failures
- [ ] A10: Server-Side Request Forgery (SSRF)

## Compliance

### Regulations (if applicable)
- [ ] **GDPR**: EU data protection
- [ ] **CCPA**: California privacy
- [ ] **HIPAA**: Healthcare data
- [ ] **PCI DSS**: Payment card data
- [ ] **SOC 2**: Security controls

## Example Customization

```markdown
## This Project Security Requirements
- Express with Helmet.js for security headers
- JWT authentication with 1-hour expiry, refresh tokens with 7-day expiry
- bcrypt for password hashing (cost factor 12)
- Parameterized queries via Prisma ORM (no raw SQL)
- Content Security Policy: default-src 'self', strict CSP
- Rate limiting: 100 requests per 15 minutes per IP
- npm audit run on every CI build, fail on high/critical
- All PII encrypted at rest using AES-256
- Security logging for all auth events and data access
- HTTPS only, TLS 1.2+, HSTS enabled
- Input validation with Zod schemas
- CSRF protection via SameSite cookies
- Regular security audits quarterly
```

## Tips
- Security is everyone's responsibility
- Use established libraries, don't roll your own crypto
- Assume breach: plan for when (not if) security fails
- Keep security simple and auditable
- Test security controls regularly
- Stay updated on security best practices
- When in doubt, consult a security expert
