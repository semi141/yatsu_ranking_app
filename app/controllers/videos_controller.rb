class VideosController < ApplicationController
  before_action :authenticate_user!, only: [:import_jaru_videos]

  def index
    @videos = Video.all
  end

  def show
    @video = Video.find(params[:id])
  end

  def import_jaru_videos
    Rails.logger.info "=== SESSION DEBUG ==="
    Rails.logger.info "session: #{session.inspect}"
    Rails.logger.info "session['warden.user.user.key']: #{session['warden.user.user.key'].inspect}"
    Rails.logger.info "=== END SESSION DEBUG ==="

    unless user_signed_in?
      redirect_to new_user_session_path, alert: "ログインしてください"
      return
    end

    real_user = warden.user(:user)

    if real_user.nil?
      Rails.logger.info "real_user is nil! :("
      redirect_to new_user_session_path, alert: "ユーザーが見つかりません"
      return
    end

    # inspect 避けて id や class でログ
    Rails.logger.info "real_user id: #{real_user.id}"
    Rails.logger.info "real_user class: #{real_user.class}"
    Rails.logger.info "real_user email: #{real_user.email}"  # email とか他の属性

    importer = ::VideoImporter.new(real_user)
    importer.import_channel_videos

    redirect_to videos_path, notice: "ジャルジャルタワーの動画を更新しました"
  end
end