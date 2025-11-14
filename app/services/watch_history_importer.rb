class WatchHistoryImporter
  def initialize(user)
    @user = user
    @youtube_service = YoutubeService.new(user)
  end

  def import_watch_history
    # ユーザーの視聴履歴を取得
    videos = @youtube_service.fetch_watch_history

    videos.each do |video_data|
      # Video を find_or_create で登録
      video = Video.find_or_initialize_by(video_id: video_data[:video_id])
      video.title = video_data[:title]
      video.description = video_data[:description]
      video.published_at = video_data[:published_at]
      video.save!

      # ユーザーと動画の紐付け（視聴データ Post）を作成
      Post.find_or_create_by(user: @user, video: video) if @user&.id
    end
  end
end
