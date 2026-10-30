(function () {
  "use strict";

  var dataElement = document.getElementById("protected-data");
  var form = document.getElementById("gate-form");
  var input = document.getElementById("gate-password");
  var submit = document.getElementById("gate-submit");
  var status = document.getElementById("gate-status");

  if (!dataElement || !form || !input || !submit || !status) {
    return;
  }

  var payload;

  try {
    payload = JSON.parse(dataElement.textContent);
  } catch (error) {
    setStatus("页面加密数据无效。", true);
    return;
  }

  function setStatus(message, isError) {
    status.textContent = message;
    status.className = isError ? "gate-status gate-error" : "gate-status";
  }

  function base64ToBytes(value) {
    var binary = window.atob(value);
    var bytes = new Uint8Array(binary.length);

    for (var i = 0; i < binary.length; i += 1) {
      bytes[i] = binary.charCodeAt(i);
    }

    return bytes;
  }

  function showError(message) {
    setStatus(message, true);
    submit.disabled = false;
    input.disabled = false;
    input.focus();
    input.select();
  }

  form.addEventListener("submit", function (event) {
    event.preventDefault();

    var password = input.value;

    if (!password) {
      setStatus("请输入访问密码。", true);
      input.focus();
      return;
    }

    submit.disabled = true;
    input.disabled = true;
    setStatus("正在解密页面…", false);

    window.crypto.subtle
      .importKey(
        "raw",
        new TextEncoder().encode(password),
        "PBKDF2",
        false,
        ["deriveKey"]
      )
      .then(function (baseKey) {
        return window.crypto.subtle.deriveKey(
          {
            name: "PBKDF2",
            salt: base64ToBytes(payload.salt),
            iterations: payload.iterations,
            hash: "SHA-256"
          },
          baseKey,
          { name: "AES-GCM", length: 256 },
          false,
          ["decrypt"]
        );
      })
      .then(function (key) {
        return window.crypto.subtle.decrypt(
          {
            name: "AES-GCM",
            iv: base64ToBytes(payload.iv),
            additionalData: new TextEncoder().encode(payload.page)
          },
          key,
          base64ToBytes(payload.ciphertext)
        );
      })
      .then(function (decrypted) {
        var html = new TextDecoder().decode(decrypted);
        document.open();
        document.write(html);
        document.close();
      })
      .catch(function () {
        showError("密码不正确，或页面数据已损坏。");
      });
  });

  input.focus();
})();
