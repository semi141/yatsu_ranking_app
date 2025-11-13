class VideoImporter
  JARUJARU_CHANNEL_ID = 'UChwgNUWPM-ksOP3BbfQHS5Q'

  def initialize(user)
    @user = user
    @youtube_service = YoutubeService.new(user)
  end

  def import_channel_videos
    videos = @youtube_service.fetch_channel_videos

    videos.each do |video_data|
      # 動画作成/更新
      video = Video.find_or_initialize_by(video_id: video_data[:video_id])
      video.title = video_data[:title]
      video.description = video_data[:description]
      video.published_at = video_data[:published_at]
      video.save!

      # Post作成（チェック）
      if @user.nil? || @user.id.nil?
        Rails.logger.error "ERROR: @user is nil or invalid! Skipping Post creation."
        next
      end

      # ここをオブジェクトに変更！！！！ user: @user, video: video
      Post.find_or_create_by(user: @user, video: video)
    end
  end
end