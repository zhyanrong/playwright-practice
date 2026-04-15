// spec: specs/login-test-plan.md
// seed: tests/seed.spec.ts

import { test, expect } from '@playwright/test';

test.describe('Login - TC-LOGIN-001', () => {
  test('Valid login — standard_user', async ({ page }) => {
    // Navigate to https://www.saucedemo.com (login page).
    await page.goto('https://www.saucedemo.com');

    // Enter username `standard_user` into username field.
    const username = page.locator('[data-test="username"]');
    await username.fill('standard_user');

    // Enter password `secret_sauce` into password field.
    const password = page.locator('[data-test="password"]');
    await password.fill('secret_sauce');

    // Click the Login button.
    const loginBtn = page.locator('[data-test="login-button"]');
    await loginBtn.click();

    // Verification: URL contains `/inventory.html`.
    await expect(page).toHaveURL(/inventory.html/);

    // Verification: The products list (inventory) is visible on the page.
    await expect(page.getByText('Products')).toBeVisible();
  });
});