// content.js — 最終版（CORS + CSRF対応）
console.log("ジャルジャル拡張: 起動！");

function getVideoId() {
  const match = location.href.match(/[?&]v=([^&]+)/);
  return match ? match[1] : null;
}

async function sendToRails(videoId) {
  console.log("送信中...", videoId);
  try {
    const response = await fetch('http://localhost:3000/api/video_watched', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.content || ''
      },
      body: JSON.stringify({ video_id: videoId }),
      credentials: 'include'  // Cookie必須！
    });

    if (response.ok) {
      console.log('登録完了！', videoId);
    } else {
      const text = await response.text();
      console.error('失敗', response.status, text);
    }
  } catch (e) {
    console.error('ネットワークエラー', e);
  }
}

// 初回実行
const initialId = getVideoId();
if (initialId) sendToRails(initialId);

// URL変更監視
let lastUrl = location.href;
setInterval(() => {
  if (location.href !== lastUrl) {
    lastUrl = location.href;
    const newId = getVideoId();
    if (newId && newId !== initialId) {
      sendToRails(newId);
    }
  }
}, 1000);