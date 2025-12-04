Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://www.youtube.com'  # YouTubeからのリクエストのみを許可

    resource '/api/*',
      headers: :any,
      methods: [:post, :options],
      credentials: true  # Cookie認証に必要
  end
end