require 'google/apis/youtube_v3'
require 'googleauth'

class YoutubeService
  JARUJARU_CHANNEL_ID = 'UChwgNUWPM-ksOP3BbfQHS5Q'

  def initialize(user = nil)
    @user = user
    @service = Google::Apis::YoutubeV3::YouTubeService.new

    # OAuth2 クライアントオブジェクトを作る
    client = Signet::OAuth2::Client.new(
      access_token: @user.access_token,
      refresh_token: @user.refresh_token,
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      token_credential_uri: 'https://oauth2.googleapis.com/token'
    )

    # トークンの有効期限切れなら自動でリフレッシュ
    if client.expired?
      client.refresh!
      @user.update(access_token: client.access_token)
    end

    @service.authorization = client
  end
  
  def fetch_channel_videos
    videos = []
    next_page_token = nil

    begin
      response = @service.list_searches(
        'snippet',
        channel_id: JARUJARU_CHANNEL_ID,
        max_results: 50,
        page_token: next_page_token,
        type: 'video',
        order: 'date'
      )

      response.items.each do |item|
        videos << {
          video_id: item.id.video_id,
          title: item.snippet.title,
          description: item.snippet.description,
          published_at: item.snippet.published_at
        }
      end

      next_page_token = response.next_page_token
    end while next_page_token.present?

    videos
  rescue Google::Apis::ClientError, Google::Apis::AuthorizationError => e
    Rails.logger.error "YouTube API error: #{e.message}"
    []
  end
end
