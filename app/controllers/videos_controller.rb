class VideosController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :watched]

  def index
    # 初期クエリ設定
    @videos = Video.all
    @title = "動画ランキング"
    @search_term = ""

    if params[:tag].present?
      # タグ検索の場合
      @videos = @videos.tagged_with(params[:tag])
      @title = "タグ: #{params[:tag]}"
      @search_term = params[:tag]
    elsif params[:q].present?
      # フリーワード検索の場合
      @videos = @videos.where("title LIKE ?", "%#{params[:q]}%")
      @title = "検索結果: #{params[:q]}"
      @search_term = params[:q]
    end

    case params[:sort]
    when "desc"
      @videos = @videos.order(watch_count: :desc)
    when "asc"
      @videos = @videos.order(watch_count: :asc)
    else
      # デフォルトはID（新しい順）でソート
      @videos = @videos.order(id: :desc)
    end

    # ページネーション（per(20)は適当な値に調整してください）
    @videos = @videos.page(params[:page]).per(20)
  end

  def show
    @video = Video.find(params[:id])

    # Watchデータの初期化（ログインしている場合のみ）
    @watch = Watch.find_or_initialize_by(user: current_user, video: @video) if user_signed_in? 

    @post = @video.posts.build
    
    # コメント一覧の取得（新しい投稿順に表示）
    @posts = @video.posts.includes(:user).order(created_at: :desc)
    
    # 関連動画の取得（既存のロジック）
    if @video.tag_list.present?
      # 重複を除き、自身を除く関連動画をランダムに5件取得
      related_videos_with_duplicates = Video.tagged_with(@video.tag_list, any: true)
                                           .where.not(id: @video.id)

      @related_videos = related_videos_with_duplicates.to_a.uniq.sample(5)
    else
      @related_videos = []
    end
  end

  def watched
    @video = Video.find(params[:id])
    
    if current_user
      # 現在のユーザーと動画の組み合わせでWatchレコードを探すか、新しく作る
      watch = Watch.find_or_initialize_by(user: current_user, video: @video)
      
      # 視聴回数を1増やすロジック（showアクションから移動）
      if watch.new_record?
        watch.watched_count = 1
      else
        watch.watched_count += 1
      end
      
      # 保存する
      watch.save
    end
    
    # JavaScriptからの非同期リクエストなので、コンテンツを返さず成功ステータス(200 OK)だけを返します
    head :ok 
  end

  def update
    @video = Video.find(params[:id])

    # 今あるタグを基礎にする
    selected_tags = @video.tag_list.map(&:strip)

    # 新規追加タグ（カンマ区切り）
    if params[:video][:new_tags].present?
      new_tags = params[:video][:new_tags].split(",").map(&:strip)
      selected_tags += new_tags
    end

    selected_tags.uniq! # 重複あったら消す

    @video.tag_list = selected_tags

    if @video.save
      redirect_to @video, notice: "タグを更新しました！"
    else
      render :show, alert: "更新に失敗しました"
    end
  end

  def remove_tag
    @video = Video.find(params[:id])
    tag = params[:tag]

    @video.tag_list.remove(tag)
    @video.save

    # UnknownFormat エラー対策として、HTML形式でリダイレクトする処理を追加
    respond_to do |format|
      format.js { render layout: false } 
      format.html { redirect_to @video, notice: "タグを削除しました。" } 
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :youtube_id, :watch_count, tag_list: [])
  end
end