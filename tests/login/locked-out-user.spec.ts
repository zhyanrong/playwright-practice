// spec: specs/PROP-2-login-test-plan.md
// seed: tests/seed.spec.ts

import { test, expect } from '@playwright/test';

test.describe('Login Functionality Suite', () => {
  test('Locked Out User Error', async ({ page }) => {
    // 1. Navigate to https://www.saucedemo.com
    await page.goto('https://www.saucedemo.com');
    
    // 2. Enter 'locked_out_user' in the username field
    await page.locator('[data-test="username"]').fill('locked_out_user');
    
    // 3. Enter 'secret_sauce' in the password field
    await page.locator('[data-test="password"]').fill('secret_sauce');
    
    // 4. Click the Login button
    await page.locator('[data-test="login-button"]').click();
    
    // Verify error message 'Epic sadface: Sorry, this user has been locked out.' is displayed
    await expect(page.getByText('Epic sadface: Sorry, this user has been locked out.')).toBeVisible();
    
    // Verify user remains on login page
    await expect(page).toHaveURL('https://www.saucedemo.com/');
    
        // Verify red X error icons appear on input fields (they are SVG elements with class error_icon)
    await expect(page.locator('.error_icon')).toHaveCount(2);
    await expect(page.locator('.form_group').filter({ has: page.locator('[data-test="username"]') }).locator('.error_icon')).toBeVisible();
    await expect(page.locator('.form_group').filter({ has: page.locator('[data-test="password"]') }).locator('.error_icon')).toBeVisible();  });
})