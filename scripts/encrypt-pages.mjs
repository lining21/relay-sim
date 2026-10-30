import { readdir, readFile, writeFile } from "node:fs/promises";
import { basename, join, resolve } from "node:path";
import { webcrypto as crypto } from "node:crypto";

const iterations = 600000;
const sourceDirectory = resolve("source");
const outputDirectory = process.cwd();

const password = process.env.PROTECT_PASSWORD;

if (!password) {
  console.error("Missing PROTECT_PASSWORD environment variable.");
  process.exitCode = 1;
} else {
  const files = (await readdir(sourceDirectory, { withFileTypes: true }))
    .filter((entry) => entry.isFile() && entry.name.endsWith(".html"))
    .map((entry) => entry.name)
    .sort();

  for (const file of files) {
    const page = basename(file);
    const sourcePath = join(sourceDirectory, page);
    const outputPath = join(outputDirectory, page);
    const plaintext = await readFile(sourcePath, "utf8");

    const salt = new Uint8Array(16);
    const iv = new Uint8Array(12);
    crypto.getRandomValues(salt);
    crypto.getRandomValues(iv);

    const baseKey = await crypto.subtle.importKey(
      "raw",
      new TextEncoder().encode(password),
      "PBKDF2",
      false,
      ["deriveKey"]
    );

    const key = await crypto.subtle.deriveKey(
      {
        name: "PBKDF2",
        salt,
        iterations,
        hash: "SHA-256"
      },
      baseKey,
      { name: "AES-GCM", length: 256 },
      false,
      ["encrypt"]
    );

    const encrypted = await crypto.subtle.encrypt(
      {
        name: "AES-GCM",
        iv,
        additionalData: new TextEncoder().encode(page)
      },
      key,
      new TextEncoder().encode(plaintext)
    );

    const payload = {
      v: 1,
      page,
      iterations,
      salt: Buffer.from(salt).toString("base64"),
      iv: Buffer.from(iv).toString("base64"),
      ciphertext: Buffer.from(encrypted).toString("base64")
    };

    const html = `<!doctype html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="robots" content="noindex,nofollow">
<title>受保护页面 · 电力系统继电保护原理虚拟仿真</title>
<link rel="stylesheet" href="assets/gate.css">
</head>
<body>
<main class="gate-shell">
  <header class="gate-header">
    <div class="gate-mark" aria-hidden="true">
      <svg width="23" height="23" viewBox="0 0 24 24" fill="none">
        <path d="M13.2 2 5.8 13h5.6L10.8 22l7.4-11h-5.6L13.2 2Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/>
      </svg>
    </div>
    <h1 class="gate-title">内容已加密</h1>
    <p class="gate-subtitle">请输入访问密码以查看本页内容</p>
  </header>
  <form id="gate-form" class="gate-form" autocomplete="off">
    <label class="gate-field" for="gate-password">
      <span class="gate-label">访问密码</span>
      <input id="gate-password" class="gate-input" type="password" name="password" autocomplete="current-password" spellcheck="false" required>
    </label>
    <p id="gate-status" class="gate-status" role="status" aria-live="polite"></p>
    <div class="gate-actions">
      <button id="gate-submit" class="gate-submit" type="submit">解锁页面</button>
    </div>
    <p class="gate-note">密码不会发送到服务器，页面内容在本地浏览器中解密。</p>
  </form>
</main>
<script id="protected-data" type="application/json">${JSON.stringify(payload)}</script>
<script src="assets/protect.js" defer></script>
</body>
</html>
`;

    await writeFile(outputPath, html, "utf8");
    console.log(`Encrypted ${page}`);
  }
}
