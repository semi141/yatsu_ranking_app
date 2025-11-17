document.addEventListener('DOMContentLoaded', () => {
  const saveBtn = document.getElementById('save');
  const tokenInput = document.getElementById('token');
  const statusDiv = document.getElementById('status');

  saveBtn.onclick = () => {
    const token = tokenInput.value.trim();
    if (!token) {
      showStatus('トークンを入力してね！', 'error');
      return;
    }

    chrome.storage.sync.set({ api_token: token }, () => {
      showStatus('✅ 保存したよ！', 'success');
    });
  };

  chrome.storage.sync.get('api_token', (data) => {
    if (data.api_token) {
      tokenInput.value = data.api_token;
      showStatus('✅ 読み込み完了', 'success');
    } else {
      showStatus('トークン未設定', 'error');
    }
  });

  function showStatus(message, type) {
    statusDiv.textContent = message;
    statusDiv.className = `status ${type}`;
  }
});