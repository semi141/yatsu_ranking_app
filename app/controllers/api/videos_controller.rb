# app/controllers/api/videos_controller.rb
class Api::VideosController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:watched]

  def watched
    youtube_id = params[:video_id].to_s.strip
    return head :bad_request if youtube_id.blank?

    user = current_user || User.create!(email: 'test@example.com', password: 'password123')

    video = Video.find_or_create_by!(youtube_id: youtube_id) do |v|
      info = YoutubeService.get_video_info(youtube_id)
      v.title        = info[:title]
      v.thumbnail    = info[:thumbnail]
      v.published_at = info[:published_at]
    end

    # ← ここが全部 render の前に実行！
    watch = Watch.find_or_initialize_by(user: user, video: video)
    watch.watched_count = (watch.watched_count || 0) + 1
    watch.save!

    # ← ここでやっと返す！
    render json: {
      message:       "視聴記録を更新しました♪",
      youtube_id:    youtube_id,
      title:         video.title,
      watched_count: watch.watched_count
    }, status: :ok
  end
end