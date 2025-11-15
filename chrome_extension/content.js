(function() {
  let lastVideoId = null;

  function getVideoId() {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get('v');
  }

  function sendToRails(videoId) {
    fetch('http://localhost:3000/api/video_watched', {
      method: 'POST',
      credentials: 'include', // Railsのcurrent_user認証用
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ video_id: videoId })
    }).then(response => {
      console.log('Rails API response:', response.status);
    }).catch(err => console.error(err));
  }

  function checkVideo() {
    const videoId = getVideoId();
    if (videoId && videoId !== lastVideoId) {
      lastVideoId = videoId;
      sendToRails(videoId);
    }
  }

  // ページが変わったりURLが変わった時もチェック
  setInterval(checkVideo, 1000);
})();