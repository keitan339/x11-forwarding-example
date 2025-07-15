import { test, expect } from "@playwright/test";

test.beforeEach(async ({ page }) => {
  await page.goto("/");
});

test.describe("App.tsx", () => {
  test("画面表示", async ({ page }) => {
    await expect(page).toHaveTitle("playwright + react + vite");
  });

  test("ボタンクリック", async ({ page }) => {
    await page.getByRole("button", { name: "切り替え" }).click();
    await expect(page.getByText("表示", { exact: true })).toBeVisible();

    await page.getByRole("button", { name: "切り替え" }).click();
    await expect(page.getByText("非表示", { exact: true })).toBeVisible();
  });
});
