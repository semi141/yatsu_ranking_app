class Api::VideosController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:watched]

  def watched
    # パラメータの受け取り
    youtube_id = params[:video_id].to_s.strip
    token = params[:token]

    # バリデーション
    return head :bad_request if youtube_id.blank?

    # ユーザー特定
    # トークンでユーザーを探す。見つからなければエラー(401 Unauthorized)を返す
    user = User.find_by(api_token: token)
    
    unless user
      render json: { error: '無効なAPIトークンです' }, status: :unauthorized
      return
    end

    info = YoutubeService.get_video_info(youtube_id)

    if info.nil? || info[:channel_id].to_s != "UChwgNUWPM-ksOP3BbfQHS5Q"
      # ジャルジャルタワーの動画ではない場合、強制終了
      return head :forbidden
    end

    # 「奴」フィルター
    video_title = info[:title].to_s
    
    # 動画タイトルに「奴」が含まれていない場合、強制終了
    unless video_title.include?('奴')
      Rails.logger.info "動画タイトルに「奴」が含まれないためブロックしました: #{video_title}"
      return head :forbidden
    end

    video = Video.find_or_create_by!(youtube_id: youtube_id) do |v|
      v.title        = info[:title]
      v.thumbnail    = info[:thumbnail]
      v.published_at = info[:published_at]
      
      v.video_id     = youtube_id
      v.youtube_id   = youtube_id
    end

    # もし既存の動画で video_id が空だった場合のために、毎回更新をかける
    if video.video_id.blank?
      video.update(video_id: youtube_id)
    end

    # 視聴記録の保存
    watch = Watch.find_or_initialize_by(user: user, video: video)
    
    if watch.new_record?
      watch.watched_count = 1
    else
      watch.watched_count += 1
    end
    watch.save!

    render json: {
      message:       "視聴記録を更新しました",
      youtube_id:    youtube_id,
      title:         video.title,
      watched_count: watch.watched_count
    }, status: :ok
  end
end