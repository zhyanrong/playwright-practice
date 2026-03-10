import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  use: {
    browserName: 'chromium',
  },
  reporter: [
    ["html", { outputFolder: 'test-results/playwright-report', open: 'never' }],
    ["junit", { outputFile: 'test-results/junit.xml' }],
    ["json", { outputFile: 'test-results/results.json' }]
  ],
});