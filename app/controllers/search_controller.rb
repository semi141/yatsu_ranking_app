class SearchController < ApplicationController
  def index
  end

  def results
    @videos = Video.all
    @videos = @videos.tagged_with(params[:tag]) if params[:tag].present?
    @videos = @videos.where("title LIKE ?", "%#{params[:keyword]}%") if params[:keyword].present?
  end
end
