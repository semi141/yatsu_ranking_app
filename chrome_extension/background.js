let lastVideoId = null;

function checkYouTubeTab() {
  chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
    const tab = tabs[0];
    if (tab && tab.url && tab.url.includes('youtube.com/watch')) {
      const match = tab.url.match(/[?&]v=([^&]+)/);
      const videoId = match ? match[1] : null;

      if (videoId && videoId !== lastVideoId) {
        lastVideoId = videoId;
        console.log("background: 新しい動画発見", videoId);
        sendToRails(videoId);
      }
    }
  });
}

function sendToRails(videoId) {
  chrome.storage.sync.get('api_token', (data) => {
    const API_TOKEN = data.api_token || '';

    if (!API_TOKEN) {
      console.error("background: トークンなし");
      return;
    }

    // chrome_extension/background.js の fetch の直前に追加
    console.log("【奴ランキング】送信開始 →", videoId);
    fetch("http://localhost:3000/api/videos/watched", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${API_TOKEN}`
      },
      body: JSON.stringify({ video_id: videoId }),
      credentials: "omit"
    })
    .then(r => {
      console.log("background: レスポンスステータス", r.status);
      
      if (r.ok) {
        return r.text().then(text => {
          if (text) {
            try { return JSON.parse(text); }
            catch { return { message: "登録完了" }; }
          } else {
            return { message: "登録完了 (empty body)" };
          }
        });
      } else {
        // エラー時はテキストで読む
        return r.text().then(text => {
          throw new Error(`HTTP ${r.status}: ${text || "不明なエラー"}`);
        });
      }
    })
    .then(body => {
      console.log("background: 完全に成功！", body);
    })
    .catch(err => {
      console.error("background: 本当に失敗", err);
    });
  });
}

// イベントリスナー
chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
  if (changeInfo.status === 'complete' && tab.url && tab.url.includes('youtube.com/watch')) {
    setTimeout(checkYouTubeTab, 2000);
  }
});

chrome.tabs.onActivated.addListener(() => {
  checkYouTubeTab();
});

checkYouTubeTab();
setInterval(checkYouTubeTab, 5000);