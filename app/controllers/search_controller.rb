class SearchController < ApplicationController
  def index
    @videos = Video.all

    # タグやキーワードがあれば絞り込む
    @videos = @videos.tagged_with(params[:tag]) if params[:tag].present?
    @videos = @videos.where("title LIKE ?", "%#{params[:keyword]}%") if params[:keyword].present?

    @videos_count = @videos.count

    case params[:sort]
    when "watch_desc"
      # 視聴回数 多い順
      @videos = @videos.left_joins(:watches)
                       .group(:id)
                       .select('videos.*, COALESCE(SUM(watches.watched_count), 0) AS total_watch_count')
                       .order(total_watch_count: :desc)
    when "watch_asc"
      # 視聴回数 少ない順
      @videos = @videos.left_joins(:watches)
                       .group(:id)
                       .select('videos.*, COALESCE(SUM(watches.watched_count), 0) AS total_watch_count')
                       .order(total_watch_count: :asc)
    when "created_desc"
      # 奴アプリ登録順 新しい順
      @videos = @videos.order(created_at: :desc)
    when "created_asc"
      # 奴アプリ登録順 古い順
      @videos = @videos.order(created_at: :asc)
    else
      # デフォルト: 視聴回数 多い順
      @videos = @videos.left_joins(:watches)
                       .group(:id)
                       .select('videos.*, COALESCE(SUM(watches.watched_count), 0) AS total_watch_count')
                       .order(total_watch_count: :desc)
    end

    render :results
  end
end