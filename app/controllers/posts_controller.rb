class PostsController < ApplicationController
  # ログイン必須のメソッドを指定
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]

  def create
    @video = Video.find(params[:video_id])
    @post = @video.posts.build(post_params)
    @post.user = current_user

    if @post.save
      respond_to do |format|
        format.html { redirect_to @video, notice: "コメントを投稿しました。" }
        format.js { flash.now[:notice] = "コメントを投稿しました！" }
      end
    else
      respond_to do |format|
        format.html do
          flash.now[:alert] = "コメントの投稿に失敗しました。"
          @posts = @video.posts.includes(:user).order(created_at: :desc)
          render 'videos/show'
        end
        format.js { render :fail, status: :unprocessable_entity }
      end
    end
  end

  def edit
      @video = Video.find(params[:video_id])
      @post = @video.posts.find(params[:id])
      
      unless current_user == @post.user
        return redirect_to @video, alert: "他のユーザーのコメントは編集できません。"
      end

      respond_to do |format|
        format.html # 通常のリクエストの場合、edit.html.erbをレンダリング
        format.js   # Turbo Frameリクエストの場合、edit.js.erbをレンダリング
      end
    end

    def update
      @video = Video.find(params[:video_id])
      @post = @video.posts.find(params[:id])
      
      if current_user != @post.user
        return redirect_to @video, alert: "他のユーザーのコメントは更新できません。"
      end
      
      if @post.update(post_params)
        respond_to do |format|
          # 成功時、非同期の場合はupdate.js.erbを実行
          format.html { redirect_to @video, notice: "コメントを編集しました。" }
          format.js { flash.now[:notice] = "コメントを編集しました！" }
        end
      else
        # 失敗時、非同期の場合はeditビューをレンダリングし、エラーを表示
        respond_to do |format|
          format.html { render :edit, status: :unprocessable_entity }
          format.js { render :edit, status: :unprocessable_entity } # edit.js.erbを再レンダリング
        end
      end
    end

  def destroy
    @video = Video.find(params[:video_id])
    @post = @video.posts.find(params[:id])
    
    # 権限チェック
    if current_user != @post.user
      return redirect_to @video, alert: "他のユーザーのコメントは削除できません。"
    end
    
    # コメントを削除
    @post.destroy
    
    respond_to do |format|
      format.html { redirect_to @video, notice: "コメントを削除しました。" }
      format.js # app/views/posts/destroy.js.erb を実行
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end