class SearchController < ApplicationController
  def index
    @videos = Video.all

    # タグ検索
    @videos = @videos.tagged_with(params[:tag]) if params[:tag].present?
    # キーワード検索
    @videos = @videos.where("title LIKE ?", "%#{params[:keyword]}%") if params[:keyword].present?

    case params[:sort]
    when "desc"
      @videos = @videos.order(watch_count: :desc)
    when "asc"
      @videos = @videos.order(watch_count: :asc)
    else
      # デフォルトは多い順
      @videos = @videos.order(watch_count: :desc) 
    end

    render :results
  end
end