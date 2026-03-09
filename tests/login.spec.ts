import { test, expect } from '@playwright/test';

test('user can log in successfully', async ({ page }) => {
  // Go to the site
  await page.goto('https://www.saucedemo.com');

  // Fill in the username and password
  await page.fill('#user-name', 'standard_user');
  await page.fill('#password', 'secret_sauce');

  // Click the login button
  await page.click('#login-button');

  // Verify we landed on the inventory page
  await expect(page).toHaveURL(/inventory/);

  console.log('Login successful!');
});


test('user can not log in with wrong password', async ({ page }) => {
  // Go to the site
  await page.goto('https://www.saucedemo.com');

  // Fill in the username and password
  await page.fill('#user-name', 'standard_user');
  await page.fill('#password', 'secret_sauce1');

  // Click the login button
  await page.click('#login-button');

  // Verify we landed on the inventory page
  await expect(page.getByText('Epic sadface: Username and password do not match any user in this service')

  ).toBeVisible();

  console.log('Login failed as expected!');
});

test('user can log out successfully', async ({ page }) => {
  // Go to the site
  await page.goto('https://www.saucedemo.com');

  // Fill in the username and password
  await page.fill('#user-name', 'standard_user');
  await page.fill('#password', 'secret_sauce');

  // Click the login button
  await page.click('#login-button');

  // Verify we landed on the inventory page
  await expect(page).toHaveURL(/inventory/);

  await page.getByRole('button', { name: 'Open Menu' }).click();

  await page.getByRole('link', { name: 'Logout' }).click();
  
  // Verify we are back on the login page
  await expect(page).toHaveURL('https://www.saucedemo.com/');

  console.log('Logout successful!');
});
