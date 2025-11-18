class VideosController < ApplicationController
  before_action :authenticate_user!, only: [:index]  # サイト開いたときのみ自動更新

  def index
    @videos = Video.all
  end

  def show
    @video = Video.find(params[:id])
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

    selected_tags.uniq!  # 重複あったら消す

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

    head :ok
  end

  private

  def video_params
    params.require(:video).permit(:title, :youtube_id, :watch_count, tag_list: [])
  end
end
