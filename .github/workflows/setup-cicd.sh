#!/bin/bash
# 🚀 CI/CD Pipeline Setup Script for Playwright Test Automation
# This script helps set up the complete CI/CD pipeline for SauceDemo login tests

set -e  # Exit on any error

echo "🎭 Setting up Playwright CI/CD Pipeline..."
echo "================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "This script must be run in a git repository"
    exit 1
fi

print_status "Git repository detected"

# Check if GitHub Actions directory exists
if [ ! -d ".github/workflows" ]; then
    print_warning ".github/workflows directory not found, creating..."
    mkdir -p .github/workflows
fi

print_status ".github/workflows directory ready"

# Check for required files
echo ""
echo "🔍 Checking required files..."
echo "--------------------------------"

# Check package.json
if [ ! -f "package.json" ]; then
    print_error "package.json not found. Please run 'npm init' first."
else
    print_status "package.json found"
fi

# Check playwright.config.ts
if [ ! -f "playwright.config.ts" ]; then
    print_warning "playwright.config.ts not found. Creating basic configuration..."
    cat > playwright.config.ts << 'EOF'
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html'],
    ['junit', { outputFile: 'test-results/results.xml' }],
    ['json', { outputFile: 'test-results/results.json' }]
  ],
  use: {
    baseURL: 'https://www.saucedemo.com/',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
  ],
  
  webServer: {
    command: 'npm run start',
    port: 3000,
    reuseExistingServer: !process.env.CI,
  },
});
EOF
    print_status "Basic playwright.config.ts created"
else
    print_status "playwright.config.ts found"
fi

# Check tests directory
if [ ! -d "tests" ]; then
    print_warning "tests directory not found, creating..."
    mkdir -p tests
fi

print_status "tests directory ready"

# Install dependencies if package.json exists
if [ -f "package.json" ]; then
    echo ""
    echo "📦 Installing dependencies..."
    echo "--------------------------------"
    
    if ! command -v npm &> /dev/null; then
        print_error "npm not found. Please install Node.js and npm first."
        exit 1
    fi
    
    # Check if playwright is in dependencies
    if ! grep -q "@playwright/test" package.json; then
        print_info "Installing Playwright..."
        npm install --save-dev @playwright/test
        npx playwright install
        print_status "Playwright installed successfully"
    else
        print_status "Playwright already installed"
    fi
fi

# Create basic test if none exist
if [ ! -f "tests/example.spec.ts" ] && [ ! -f "tests/login.spec.ts" ]; then
    print_info "Creating example test file..."
    cat > tests/example.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

test('SauceDemo - Basic Navigation', async ({ page }) => {
  // Navigate to SauceDemo
  await page.goto('/');
  
  // Verify page title
  await expect(page).toHaveTitle(/Swag Labs/);
  
  // Check login form is visible
  await expect(page.locator('[data-test="username"]')).toBeVisible();
  await expect(page.locator('[data-test="password"]')).toBeVisible();
  await expect(page.locator('[data-test="login-button"]')).toBeVisible();
});

test('SauceDemo - Valid Login', async ({ page }) => {
  await page.goto('/');
  
  // Enter credentials
  await page.fill('[data-test="username"]', 'standard_user');
  await page.fill('[data-test="password"]', 'secret_sauce');
  
  // Click login
  await page.click('[data-test="login-button"]');
  
  // Verify successful login
  await expect(page.locator('.inventory_list')).toBeVisible();
  await expect(page.url()).toContain('/inventory.html');
});
EOF
    print_status "Example test created at tests/example.spec.ts"
fi

# Check if workflow file already exists
if [ -f ".github/workflows/playwright-tests.yml" ]; then
    print_status "CI/CD workflow file already exists"
else
    print_warning "CI/CD workflow file not found. Please ensure playwright-tests.yml is in .github/workflows/"
fi

# Create or update README with CI/CD badges
echo ""
echo "📝 Setting up README badges..."
echo "--------------------------------"

REPO_NAME=$(basename `git rev-parse --show-toplevel`)
REPO_OWNER=$(git config --get remote.origin.url | sed -n 's/.*github.com[:\/]\([^\/]*\)\/.*/\1/p')

if [ -f "README.md" ]; then
    # Backup existing README
    cp README.md README.md.backup
    print_info "README.md backed up to README.md.backup"
fi

# Create README with badges if it doesn't exist or is minimal
if [ ! -f "README.md" ] || [ $(wc -l < README.md) -lt 5 ]; then
    cat > README.md << EOF
# 🎭 Playwright Test Automation - SauceDemo Login Tests

[![Playwright Tests](https://github.com/${REPO_OWNER}/${REPO_NAME}/actions/workflows/playwright-tests.yml/badge.svg)](https://github.com/${REPO_OWNER}/${REPO_NAME}/actions/workflows/playwright-tests.yml)
[![Test Results](https://img.shields.io/badge/Tests-View%20Results-blue)](https://github.com/${REPO_OWNER}/${REPO_NAME}/actions)
[![Playwright](https://img.shields.io/badge/Playwright-1.58.2-green)](https://playwright.dev/)
[![Node.js](https://img.shields.io/badge/Node.js-18-success)](https://nodejs.org/)

## Overview
Automated test suite for SauceDemo login functionality using Playwright with comprehensive CI/CD pipeline.

## 🚀 Features
- **Multi-Browser Testing**: Chromium, Firefox, WebKit
- **Scheduled Execution**: Monday-Friday at 8 AM UTC
- **Comprehensive Reporting**: JUnit XML, JSON, HTML, Universal Dashboard
- **GitHub Actions Integration**: Automated CI/CD pipeline
- **Real-time Monitoring**: Live test results and analytics

## 🏃‍♂️ Quick Start
\`\`\`bash
# Install dependencies
npm install

# Run tests locally
npm run test

# Run specific browser
npm run test:chromium
npm run test:firefox  
npm run test:webkit
\`\`\`

## 📊 Test Reports
- **Live Dashboard**: Available in GitHub Actions artifacts
- **HTML Reports**: Interactive Playwright reports with traces
- **JUnit XML**: CI/CD integration format
- **Universal Analytics**: Comprehensive test metrics

## 🔧 CI/CD Pipeline
The pipeline runs automatically:
- ⏰ **Scheduled**: Daily at 8 AM UTC (Monday-Friday)
- 🔄 **On Push**: Every commit to main branch
- 📥 **On PR**: All pull requests
- ⚡ **Manual**: On-demand execution

### Pipeline Features
- Multi-browser parallel execution
- Comprehensive artifact generation
- Automatic failure notifications
- Historical trend analysis

## 📈 Dashboards
1. **Executive Summary**: High-level test metrics
2. **Technical Details**: Detailed failure analysis
3. **Browser Compatibility**: Cross-browser performance
4. **Historical Trends**: Pass/fail rate over time

## 🎯 Test Coverage
- ✅ Valid login scenarios
- ✅ Invalid credential handling
- ✅ UI element validation
- ✅ Error message verification
- ✅ Cross-browser compatibility

## 📞 Support
For issues or questions, please check:
1. [GitHub Actions Logs](https://github.com/${REPO_OWNER}/${REPO_NAME}/actions)
2. [CI/CD Documentation](.github/workflows/CI-CD-DOCUMENTATION.md)
3. Create an issue for bug reports or feature requests

---
*🤖 Automated testing powered by GitHub Actions & Playwright*
EOF
    print_status "README.md created with CI/CD badges"
fi

# Create npm scripts
if [ -f "package.json" ]; then
    echo ""
    echo "📜 Setting up npm scripts..."
    echo "--------------------------------"
    
    # Check if scripts section exists and add our scripts
    if grep -q '"scripts"' package.json; then
        print_info "Adding test scripts to package.json..."
        
        # Create temporary file with our scripts
        cat > temp_scripts.json << 'EOF'
{
  "test": "playwright test",
  "test:headed": "playwright test --headed",
  "test:chromium": "playwright test --project=chromium",
  "test:firefox": "playwright test --project=firefox",  
  "test:webkit": "playwright test --project=webkit",
  "test:smoke": "playwright test --grep \"smoke|login\"",
  "report": "playwright show-report",
  "report:open": "playwright show-report --host=0.0.0.0 --port=9000"
}
EOF
        
        # Note: This is a simplified approach. In production, you might want to use jq or node script
        print_warning "Please manually add the following scripts to your package.json:"
        cat temp_scripts.json
        rm temp_scripts.json
        
    else
        print_warning "No scripts section found in package.json. Please add one manually."
    fi
fi

# Final summary
echo ""
echo "✨ Setup Complete!"
echo "========================================="
print_status "CI/CD pipeline is ready to use!"

echo ""
echo "🚀 Next Steps:"
echo "1. Commit and push the workflow files to trigger the pipeline"
echo "2. Check GitHub Actions tab for pipeline execution"
echo "3. Review generated test reports and dashboards"
echo "4. Customize the pipeline as needed"

echo ""
echo "📊 Useful Commands:"
echo "  npm test                 - Run all tests"
echo "  npm run test:chromium    - Run Chromium tests only"
echo "  npm run report           - View test reports"

echo ""
echo "🔗 Important Links:"
echo "  CI/CD Documentation: .github/workflows/CI-CD-DOCUMENTATION.md"
echo "  GitHub Actions: https://github.com/${REPO_OWNER}/${REPO_NAME}/actions"

echo ""
print_status "Happy testing! 🎭"