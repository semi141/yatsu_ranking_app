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
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ video_id: videoId }),
      credentials: 'include'  // Cookieを送る！
    });

    if (response.ok) {
      console.log('登録完了！', videoId);
    } else {
      console.error('失敗', response.status);
    }
  } catch (e) {
    console.error('エラー', e);
  }
}

// 2秒待機して実行
setTimeout(() => {
  const videoId = getVideoId();
  if (videoId) sendToRails(videoId);
}, 2000);