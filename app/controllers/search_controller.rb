class SearchController < ApplicationController
  def index
    @videos = Video.all

    case params[:sort]
    when "desc"
      @videos = @videos.order(watch_count: :desc)
    when "asc"
      @videos = @videos.order(watch_count: :asc)
    end
  end

  def results
    @videos = Video.all
    @videos = @videos.tagged_with(params[:tag]) if params[:tag].present?
    @videos = @videos.where("title LIKE ?", "%#{params[:keyword]}%") if params[:keyword].present?
  end
end
