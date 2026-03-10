# 🔐 Repository Configuration Guide
## GitHub Settings for Playwright CI/CD Pipeline

This guide outlines the recommended repository settings and configurations for optimal CI/CD pipeline operation.

## 🛡️ Security Settings

### Required Secrets (Optional Enhancements)
Navigate to **Settings > Secrets and variables > Actions** to add:

| Secret Name | Purpose | Required |
|------------|---------|----------|
| `SLACK_WEBHOOK_URL` | Slack notifications | ❌ Optional |
| `EMAIL_USERNAME` | Email notification sender | ❌ Optional |
| `EMAIL_PASSWORD` | Email authentication | ❌ Optional |
| `JIRA_API_TOKEN` | Jira integration (if needed) | ❌ Optional |

### Environment Protection Rules
For production deployments, configure environment protection:
- **Reviewers**: Require manual approval for deployments
- **Branch Restrictions**: Limit deployments to specific branches
- **Environment Secrets**: Separate secrets per environment

## ⚙️ Branch Protection Rules

### Recommended Settings
Navigate to **Settings > Branches** and configure:

#### Main Branch Protection
```yaml
Branch name pattern: main
Rules:
  ✅ Require a pull request before merging
  ✅ Require status checks to pass before merging
    - playwright-tests (CI/CD Pipeline)
    - test / Run Playwright Tests
  ✅ Require branches to be up to date before merging
  ✅ Require conversation resolution before merging
  ❌ Restrict pushes that create files larger than 100 MB
  ✅ Allow force pushes (for administrators only)
  ✅ Allow deletions (for administrators only)
```

#### Required Status Checks
Ensure these checks pass before merging:
- `playwright-tests`
- `test / Run Playwright Tests`
- `consolidate-reports / Consolidate Test Reports`

## 📊 GitHub Actions Settings

### Workflow Permissions
Navigate to **Settings > Actions > General**:

#### Workflow permissions
```yaml
✅ Read and write permissions
✅ Allow GitHub Actions to create and approve pull requests
```

#### Fork pull request workflows
```yaml
✅ Run workflows from fork pull requests
   - Require approval for first-time contributors
```

### Artifact Retention
Configure artifact retention policy:
- **Default**: 30 days (recommended)
- **Minimum**: 7 days for cost efficiency
- **Maximum**: 90 days for compliance

## 🎭 Playwright Configuration

### Recommended playwright.config.ts Settings
```typescript
export default defineConfig({
  // CI-optimized settings
  workers: process.env.CI ? 1 : undefined,
  retries: process.env.CI ? 2 : 0,
  forbidOnly: !!process.env.CI,
  
  // Reporting for CI/CD
  reporter: [
    ['html'],
    ['junit', { outputFile: 'test-results/results.xml' }],
    ['json', { outputFile: 'test-results/results.json' }]
  ],
  
  // CI-safe settings
  use: {
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure'
  }
});
```

### Package.json Scripts
```json
{
  "scripts": {
    "test": "playwright test",
    "test:ci": "playwright test --reporter=html,junit,json",
    "test:headed": "playwright test --headed",
    "test:debug": "playwright test --debug",
    "report": "playwright show-report"
  }
}
```

## 📈 Monitoring & Notifications

### GitHub Actions Monitoring
1. **Dashboard**: Monitor pipeline health from Actions tab
2. **Email Notifications**: Enable for workflow failures
3. **Mobile App**: Install GitHub mobile for real-time alerts

### External Integration Options
```yaml
# Slack Webhook Example
https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK

# Email SMTP Configuration
SMTP_SERVER: smtp.gmail.com
SMTP_PORT: 587
SMTP_SECURITY: STARTTLS
```

## 🔧 Performance Optimization

### Workflow Performance
1. **Parallel Execution**: Matrix strategy for multiple browsers
2. **Caching**: Node.js dependencies and Playwright browsers
3. **Artifact Management**: Selective upload to reduce storage

### Resource Limits
```yaml
# Workflow timeout settings
timeout-minutes: 30  # Prevent hanging workflows
jobs:
  test:
    timeout-minutes: 30
    steps:
      - timeout-minutes: 10  # Per-step timeouts
```

## 📊 Analytics & Reporting

### Built-in Analytics
- **Workflow runs**: Success/failure trends
- **Duration tracking**: Performance over time
- **Resource usage**: Minutes consumed

### Custom Metrics
```typescript
// Add to test files for custom metrics
test.describe('Performance Tests', () => {
  test('measure page load time', async ({ page }) => {
    const start = Date.now();
    await page.goto('/');
    const loadTime = Date.now() - start;
    console.log(`Page load time: ${loadTime}ms`);
  });
});
```

## 🚨 Troubleshooting Guide

### Common Issues & Solutions

#### Workflow Not Triggering
```yaml
# Check branch protection rules
# Verify workflow file syntax
# Confirm repository permissions
```

#### Test Failures in CI
```yaml
# Review CI environment differences
# Check browser versions
# Verify test data and fixtures
```

#### Artifact Upload Failures
```yaml
# Verify file paths exist
# Check artifact size limits (10GB max)
# Ensure proper permissions
```

#### Notification Issues  
```yaml
# Verify webhook URLs
# Check secret configuration
# Test notification channels manually
```

## 📋 Pre-deployment Checklist

### Before Enabling CI/CD
- [ ] Repository has proper branch protection
- [ ] Workflow file syntax is valid
- [ ] Test files execute successfully locally
- [ ] Required secrets are configured (if using notifications)
- [ ] Team members have appropriate access levels

### First Run Validation
- [ ] Workflow triggers on schedule (wait for 8 AM UTC)
- [ ] Tests execute on all configured browsers
- [ ] Reports generate correctly
- [ ] Artifacts upload successfully
- [ ] Notifications work (if configured)

### Ongoing Maintenance
- [ ] Weekly review of test results
- [ ] Monthly cleanup of old artifacts
- [ ] Quarterly workflow optimization review
- [ ] Annual security audit of secrets and permissions

## 🎯 Best Practices

### Security
1. **Least Privilege**: Grant minimum required permissions
2. **Secret Rotation**: Regular update of API keys and tokens
3. **Audit Logging**: Monitor workflow execution and changes
4. **Dependency Scanning**: Regular security updates

### Reliability
1. **Test Stability**: Minimize flaky tests with proper waits
2. **Error Handling**: Graceful failure recovery
3. **Resource Management**: Efficient use of CI/CD minutes
4. **Monitoring**: Proactive issue detection

### Maintainability
1. **Documentation**: Keep workflows well-documented
2. **Version Control**: Track workflow changes
3. **Modularity**: Reusable workflow components
4. **Standards**: Consistent naming and organization

---

## 📞 Support Contacts

- **CI/CD Issues**: Check GitHub Actions documentation
- **Test Failures**: Review Playwright logs and reports
- **Security Concerns**: Contact repository administrators
- **Performance Issues**: Monitor resource usage and optimize

*📖 Keep this guide updated as your pipeline evolves and requirements change.*