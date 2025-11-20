class Api::VideosController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:watched]

  def watched
    youtube_id = params[:video_id].to_s.strip
    return head :bad_request if youtube_id.blank?

    user = current_user || User.find_by(email: 'test@example.com') || User.create!(email: 'test@example.com', password: 'password123')

    info = YoutubeService.get_video_info(youtube_id)

    puts "DEBUG: channel_id = #{info[:channel_id]}"
    puts "DEBUG: info = #{info.inspect}"

    if info.nil? || info[:channel_id].to_s != "UChwgNUWPM-ksOP3BbfQHS5Q"
      Rails.logger.debug "Forbidden: channel_id=#{info&.[](:channel_id)}"
      return head :forbidden
    end

    video = Video.find_or_create_by!(youtube_id: youtube_id) do |v|
      v.title        = info[:title]
      v.thumbnail    = info[:thumbnail]
      v.published_at = info[:published_at]
      v.watch_count
    end

    watch = Watch.find_or_initialize_by(user: user, video: video)
    if watch.new_record?
      watch.watched_count = 1  # 新規作成なら1からスタート
    else
      watch.watched_count += 1 # 既存なら+1
    end
    watch.save!

    render json: {
      message:       "視聴記録を更新しました♪",
      youtube_id:    youtube_id,
      title:         video.title,
      watched_count: watch.watched_count
    }, status: :ok
  end
end