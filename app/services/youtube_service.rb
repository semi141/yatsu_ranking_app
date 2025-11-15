require 'net/http'
require 'uri'
require 'json'

class YoutubeService
  BASE_URL = "https://www.googleapis.com/youtube/v3/videos"

  def self.get_video_info(video_id)
    api_key = ENV['YOUTUBE_API_KEY']
    url = "#{BASE_URL}?id=#{video_id}&key=#{api_key}&part=snippet"

    uri = URI.parse(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    item = data["items"]&.first
    return nil unless item

    snippet = item["snippet"]

    {
      title: snippet["title"],
      description: snippet["description"],
      published_at: snippet["publishedAt"]
    }
  rescue => e
    Rails.logger.error "YouTube API error: #{e.message}"
    nil
  end
end
