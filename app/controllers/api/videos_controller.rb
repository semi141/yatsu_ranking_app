class Api::VideosController < ApplicationController
  #before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:watched]

  def watched
    video_id = params[:video_id]
    return head :bad_request unless video_id

    video = Video.find_or_create_by!(youtube_id: video_id) do |v|
      info = YoutubeService.get_video_info(video_id)
      v.title = info[:title]
      v.thumbnail = info[:thumbnail]
      v.published_at = info[:published_at]
    end

    Post.find_or_create_by!(user: current_user, video: video) do |p|
      p.content = "YouTubeで視聴！自動登録"
    end

    head :ok
  end
end