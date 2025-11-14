class VideosController < ApplicationController
  before_action :authenticate_user!, only: [:index]  # サイト開いたときのみ自動更新

  def index
    # サイト開いたタイミングで自動更新（視聴履歴反映）
    WatchHistoryImporter.new(current_user).import_watch_history

    # 一覧表示（新しい順）
    @videos = Video.order(published_at: :desc)
  end

  def show
    @video = Video.find(params[:id])
  end
end
