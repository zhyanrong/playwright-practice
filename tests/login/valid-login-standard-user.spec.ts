// spec: specs/login-test-plan.md
// seed: tests/seed.spec.ts

import { test, expect } from '@playwright/test';

test.describe('Login Functionality Tests', () => {
  test('Valid Login with Standard User', async ({ page }) => {
    // Navigate to the login page
    await page.goto('https://www.saucedemo.com/');
    // expect: Login page should be displayed
    await expect(page.getByRole('button', { name: 'Login' })).toBeVisible();
    // Verify username field is present and empty
    await expect(page.getByRole('textbox', { name: 'Username' })).toBeVisible();
    // expect: Username field should be empty
    await expect(page.locator('[data-test="username"]')).toHaveValue('');
    // Verify password field is present and empty
    await expect(page.getByRole('textbox', { name: 'Password' })).toBeVisible();
    // expect: Password field should be empty
    await expect(page.locator('[data-test="password"]')).toHaveValue('');
    // Verify accepted usernames are listed
    await expect(page.getByRole('heading', { name: 'Accepted usernames are:' })).toBeVisible();
    // Verify password for all users is shown
    await expect(page.getByRole('heading', { name: 'Password for all users:' })).toBeVisible();
    // Enter 'standard_user' in the username field
    await page.locator('[data-test="username"]').fill('standard_user');
    // Enter 'secret_sauce' in the password field
    await page.locator('[data-test="password"]').fill('secret_sauce');
    // Click the Login button
    await page.locator('[data-test="login-button"]').click();
    // expect: Page should navigate to /inventory.html
    await expect(page).toHaveURL('https://www.saucedemo.com/inventory.html');
    // expect: Title should be 'Swag Labs'
    await expect(page).toHaveTitle('Swag Labs');
    // expect: Product grid should be visible
    await expect(page.locator('.inventory_item').first()).toBeVisible();
  });
});