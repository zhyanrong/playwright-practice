# SauceDemo Login Test Plan

## Application Overview

Comprehensive test plan for the login functionality of the SauceDemo website (https://www.saucedemo.com/). This plan covers positive and negative test cases, edge cases, and validation of login page elements for various user types including standard, locked out, problem, and performance glitch users.

## Test Scenarios

### 1. Login Functionality Tests

**Seed:** `tests/seed.spec.ts`

#### 1.1. Valid Login with Standard User

**File:** `tests/login/valid-login-standard-user.spec.ts`

**Steps:**
  1. Navigate to the login page
    - expect: The page should redirect to the inventory page with title 'Swag Labs'
    - expect: Products should be displayed on the page
  2. Verify username field is present and empty
    - expect: Username field should be empty
  3. Verify password field is present and empty
    - expect: Password field should be empty
  4. Verify login button is present
    - expect: Login button should be visible and enabled
  5. Verify accepted usernames are listed
    - expect: Accepted usernames list should be displayed
  6. Verify password for all users is shown
    - expect: Password hint should be displayed
  7. Enter 'standard_user' in the username field
  8. Enter 'secret_sauce' in the password field
  9. Click the Login button
    - expect: Page should navigate to /inventory.html
    - expect: Title should be 'Swag Labs'
    - expect: Product grid should be visible

#### 1.2. Invalid Username Login Attempt

**File:** `tests/login/invalid-username.spec.ts`

**Steps:**
  1. Navigate to the login page
    - expect: Login page should be displayed
  2. Enter 'invalid_user' in the username field
  3. Enter 'secret_sauce' in the password field
  4. Click the Login button
    - expect: Error message 'Epic sadface: Username and password do not match any user in this service' should appear
    - expect: Login page should remain displayed

#### 1.3. Locked Out User Login Attempt

**File:** `tests/login/locked-out-user.spec.ts`

**Steps:**
  1. Navigate to the login page
    - expect: Login page should be displayed
  2. Enter 'locked_out_user' in the username field
  3. Enter 'secret_sauce' in the password field
  4. Click the Login button
    - expect: Error message 'Epic sadface: Sorry, this user has been locked out.' should appear
    - expect: Login page should remain displayed

#### 1.4. Problem User Login

**File:** `tests/login/problem-user-login.spec.ts`

**Steps:**
  1. Navigate to the login page
    - expect: Login page should be displayed
  2. Enter 'problem_user' in the username field
  3. Enter 'secret_sauce' in the password field
  4. Click the Login button
    - expect: Page should navigate to inventory page (note: problem_user may have UI issues on subsequent pages)

#### 1.5. Performance Glitch User Login

**File:** `tests/login/performance-glitch-user.spec.ts`

**Steps:**
  1. Navigate to the login page
    - expect: Login page should be displayed
  2. Enter 'performance_glitch_user' in the username field
  3. Enter 'secret_sauce' in the password field
  4. Click the Login button
    - expect: Page should eventually navigate to inventory page (may take longer than usual due to performance glitch)

#### 1.6. Login with Empty Username

**File:** `tests/login/empty-username.spec.ts`

**Steps:**
  1. Navigate to the login page
    - expect: Login page should be displayed
  2. Leave username field empty
  3. Enter 'secret_sauce' in the password field
  4. Click the Login button
    - expect: Error message 'Epic sadface: Username is required' should appear

#### 1.7. Login with Empty Password

**File:** `tests/login/empty-password.spec.ts`

**Steps:**
  1. Navigate to the login page
    - expect: Login page should be displayed
  2. Enter 'standard_user' in the username field
  3. Leave password field empty
  4. Click the Login button
    - expect: Error message 'Epic sadface: Password is required' should appear

#### 1.8. Login with Both Fields Empty

**File:** `tests/login/both-fields-empty.spec.ts`

**Steps:**
  1. Navigate to the login page
    - expect: Login page should be displayed
  2. Leave both username and password fields empty
  3. Click the Login button
    - expect: Error message 'Epic sadface: Username is required' should appear

#### 1.9. Login with Wrong Password

**File:** `tests/login/wrong-password.spec.ts`

**Steps:**
  1. Navigate to the login page
    - expect: Login page should be displayed
  2. Enter 'standard_user' in the username field
  3. Enter 'wrong_password' in the password field
  4. Click the Login button
    - expect: Error message 'Epic sadface: Username and password do not match any user in this service' should appear

#### 1.10. Error Message Dismissal

**File:** `tests/login/error-message-dismissal.spec.ts`

**Steps:**
  1. Navigate to the login page
    - expect: Login page should be displayed
  2. Enter invalid credentials (e.g., empty username)
  3. Click the Login button
    - expect: Error message should appear
  4. Click the close button (X) on the error message
    - expect: Error message should disappear

#### 1.11. Login Page UI Elements Verification

**File:** `tests/login/ui-elements-verification.spec.ts`

**Steps:**
  1. Navigate to the login page
    - expect: Login page should be displayed
  2. Verify username input field
    - expect: Username textbox with placeholder 'Username' should be present
  3. Verify password input field
    - expect: Password textbox with placeholder 'Password' should be present
  4. Verify login button
    - expect: Login button with text 'Login' should be present
  5. Verify accepted usernames display
    - expect: Accepted usernames section should list all valid usernames
  6. Verify password hint
    - expect: Password hint should display 'secret_sauce'

#### 1.12. Field Value Retention After Error

**File:** `tests/login/field-retention-after-error.spec.ts`

**Steps:**
  1. Navigate to the login page
    - expect: Login page should be displayed
  2. Enter 'test_user' in username field
  3. Enter 'test_pass' in password field
  4. Click the Login button
    - expect: Error message should appear
    - expect: Username field should still contain 'test_user'
    - expect: Password field should still contain 'test_pass'
