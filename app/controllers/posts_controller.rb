class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]

  def new
    @video = Video.find(params[:video_id])
    @post = @video.posts.build
  end

  def create
    @video = Video.find(params[:video_id])
    @post = @video.posts.build(post_params)
    @post.user = current_user

    if @post.save
      redirect_to @video, notice: "投稿を作成しました！"
    else
      Rails.logger.debug(@post.errors.full_messages)  # ←ここ追加
      render :new
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to videos_path, notice: "投稿を更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to videos_path, notice: "投稿を削除しました！"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :video_id)
  end
end
