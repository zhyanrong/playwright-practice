# PROP-2 Login Test Plan

## Application Overview

Comprehensive test plan for user story PROP-2: "As a registered user, I want to log in to saucedemo.com so that I can access the products page". This plan covers all login scenarios including valid authentication, error handling, and edge cases for the SauceDemo login functionality at https://www.saucedemo.com.

## Test Scenarios

### 1. Login Functionality Suite

**Seed:** `tests/seed.spec.ts`

#### 1.1. Valid Login - Standard User

**File:** `tests/login/valid-login-standard-user.spec.ts`

**Steps:**
  1. Navigate to https://www.saucedemo.com
    - expect: Login page loads successfully
    - expect: Username textbox is visible
    - expect: Password textbox is visible
    - expect: Login button is visible
    - expect: Page title is 'Swag Labs'
  2. Enter 'standard_user' in the username field
    - expect: Username is entered correctly in the textbox
  3. Enter 'secret_sauce' in the password field
    - expect: Password is entered correctly in the textbox
  4. Click the Login button
    - expect: User is redirected to https://www.saucedemo.com/inventory.html
    - expect: Products page loads successfully
    - expect: Products header is visible
    - expect: Product list with 6 items is displayed
    - expect: 'Add to cart' buttons are visible for all products
    - expect: No error messages are shown

#### 1.2. Valid Login - Performance Glitch User

**File:** `tests/login/performance-glitch-user.spec.ts`

**Steps:**
  1. Navigate to https://www.saucedemo.com
    - expect: Login page loads successfully
  2. Enter 'performance_glitch_user' in the username field
    - expect: Username is entered correctly
  3. Enter 'secret_sauce' in the password field
    - expect: Password is entered correctly
  4. Click the Login button
    - expect: Login process takes longer than normal (>5 seconds)
    - expect: User is eventually redirected to inventory.html
    - expect: Products page loads with all items visible
    - expect: No error messages are shown

#### 1.3. Locked Out User Error

**File:** `tests/login/locked-out-user.spec.ts`

**Steps:**
  1. Navigate to https://www.saucedemo.com
    - expect: Login page loads successfully
  2. Enter 'locked_out_user' in the username field
    - expect: Username is entered correctly
  3. Enter 'secret_sauce' in the password field
    - expect: Password is entered correctly
  4. Click the Login button
    - expect: Error message 'Epic sadface: Sorry, this user has been locked out.' is displayed
    - expect: User remains on login page
    - expect: URL is still https://www.saucedemo.com/
    - expect: Red X error icons appear on input fields

#### 1.4. Invalid Password Error

**File:** `tests/login/invalid-password.spec.ts`

**Steps:**
  1. Navigate to https://www.saucedemo.com
    - expect: Login page loads successfully
  2. Enter 'standard_user' in the username field
    - expect: Username is entered correctly
  3. Enter 'wrong_password' in the password field
    - expect: Password is entered correctly
  4. Click the Login button
    - expect: Error message 'Epic sadface: Username and password do not match any user in this service' is displayed
    - expect: User remains on login page
    - expect: No navigation occurs
    - expect: Red X error icons appear on input fields

#### 1.5. Unknown Username Error

**File:** `tests/login/unknown-username.spec.ts`

**Steps:**
  1. Navigate to https://www.saucedemo.com
    - expect: Login page loads successfully
  2. Enter 'unknown_user' in the username field
    - expect: Unknown username is entered
  3. Enter 'some_password' in the password field
    - expect: Password is entered
  4. Click the Login button
    - expect: Error message 'Epic sadface: Username and password do not match any user in this service' is displayed
    - expect: User remains on login page
    - expect: No authentication occurs

#### 1.6. Empty Username Validation

**File:** `tests/login/empty-username.spec.ts`

**Steps:**
  1. Navigate to https://www.saucedemo.com
    - expect: Login page loads successfully
  2. Leave username field empty
    - expect: Username field remains empty
  3. Enter 'secret_sauce' in the password field
    - expect: Password is entered correctly
  4. Click the Login button
    - expect: Error message 'Epic sadface: Username is required' is displayed
    - expect: User remains on login page
    - expect: Form validation prevents submission

#### 1.7. Empty Password Validation

**File:** `tests/login/empty-password.spec.ts`

**Steps:**
  1. Navigate to https://www.saucedemo.com
    - expect: Login page loads successfully
  2. Enter 'standard_user' in the username field
    - expect: Username is entered correctly
  3. Leave password field empty
    - expect: Password field remains empty
  4. Click the Login button
    - expect: Error message 'Epic sadface: Password is required' is displayed
    - expect: User remains on login page
    - expect: Form validation prevents authentication

#### 1.8. Both Fields Empty Validation

**File:** `tests/login/both-fields-empty.spec.ts`

**Steps:**
  1. Navigate to https://www.saucedemo.com
    - expect: Login page loads successfully
  2. Leave both username and password fields empty
    - expect: Both fields remain empty
  3. Click the Login button
    - expect: Error message 'Epic sadface: Username is required' is displayed (username error takes priority)
    - expect: User remains on login page
    - expect: No authentication attempt occurs

#### 1.9. UI Element Validation

**File:** `tests/login/ui-elements-validation.spec.ts`

**Steps:**
  1. Navigate to https://www.saucedemo.com
    - expect: Page loads successfully
  2. Verify presence of all login form elements
    - expect: Username textbox with data-test='username' is present
    - expect: Password textbox with data-test='password' is present
    - expect: Login button with data-test='login-button' is present
    - expect: Page title shows 'Swag Labs'
    - expect: Helper text shows accepted usernames
    - expect: Helper text shows password for all users as 'secret_sauce'
  3. Verify form accessibility and attributes
    - expect: Username field has proper label/placeholder
    - expect: Password field has proper label/placeholder
    - expect: Login button is properly labeled
    - expect: Tab order is logical (username → password → login button)

#### 1.10. Session State After Login

**File:** `tests/login/session-persistence.spec.ts`

**Steps:**
  1. Login successfully with standard_user credentials
    - expect: Successfully redirected to inventory page
  2. Navigate directly to inventory.html in a new tab/window without logging in again
    - expect: Session persists and user remains authenticated
    - expect: Inventory page loads without redirect to login
    - expect: Products are visible and functional
  3. Refresh the page while on inventory.html
    - expect: Session persists after page refresh
    - expect: User remains on inventory page
    - expect: All products and functionality remain available
