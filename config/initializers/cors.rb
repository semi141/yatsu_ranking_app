Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://www.youtube.com'  # YouTubeからのリクエストを許可！

    resource '/api/*',
      headers: :any,
      methods: [:post, :options],
      credentials: true  # Cookie認証に必要！
  end

  # 開発中は localhost も許可（後で削除OK）
  allow do
    origins 'http://localhost:3000', 'https://yatsu-ranking-viewer-5fd11a800c35.herokuapp.com'
    resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options], credentials: true
  end
end