console.log("奴ランキング見る奴: 起動！");

function getVideoId() {
  const match = location.href.match(/[?&]v=([^&]+)/);
  return match ? match[1] : null;
}

// ページ読み込み後に実行
document.addEventListener("DOMContentLoaded", () => {
  setTimeout(() => {
    const videoId = getVideoId();
    if (videoId) {
      console.log("動画ID発見:", videoId);

      // background.js にメッセージ送信
      chrome.runtime.sendMessage({
        type: "VIDEO_WATCHED",
        videoId: videoId
      }, (response) => {
        if (response?.status === "success") {
          console.log("✅ 奴アプリに登録完了！", response.body);
        } else {
          console.error("❌ 登録失敗:", response?.error || response);
        }
      });
    }
  }, 2000); // YouTubeの読み込み待ち
});