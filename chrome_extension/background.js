chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === "VIDEO_WATCHED") {
    chrome.storage.sync.get('api_token', (data) => {
      const API_TOKEN = data.api_token || '';

      if (!API_TOKEN) {
        sendResponse({ status: "error", error: "トークンが設定されてないよ！ポップアップで入力してね" });
        return;
      }

      fetch("http://localhost:3000/api/video_watched", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${API_TOKEN}`
        },
        body: JSON.stringify({ youtube_id: message.videoId }),
        credentials: "omit"
      })
      .then(r => r.json().then(body => ({ status: r.status, body })))
      .then(res => sendResponse(res))
      .catch(err => sendResponse({ status: "error", error: err.message }));

      return true;
    });
    return true;
  }
});