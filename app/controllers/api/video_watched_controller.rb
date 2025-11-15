module Api
  class VideoWatchedController < ApplicationController
    protect_from_forgery with: :null_session

    def create
      video_id = params[:video_id]
      return head :bad_request unless video_id.present?

      info = YoutubeService.new(current_user).get_video_info(video_id)

      video = Video.find_or_initialize_by(video_id: video_id)
      if info
        video.title = info[:title]
        video.description = info[:description]
        video.published_at = info[:published_at]
        video.url = "https://www.youtube.com/watch?v=#{video_id}"
      else
        video.title ||= "未取得の動画"
        video.published_at ||= Time.current
        video.url = "https://www.youtube.com/watch?v=#{video_id}"
      end
      video.save!

      Post.find_or_create_by(user: current_user, video: video) if current_user

      render json: { status: 'ok', video_id: video.video_id }
    end
  end
end