class VideosController < ApplicationController
  before_action :authenticate_user!, only: [:index]  # サイト開いたときのみ自動更新

  def index
    @videos = Video.all
  end

  def show
    @video = Video.find(params[:id])
  end
end