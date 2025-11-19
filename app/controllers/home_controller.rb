class HomeController < ApplicationController
  def ranking
    @tab = params[:tab] || "my"
    # 全体ランキング（みんなの視聴回数合計）
    @all_rankings = Video.select('videos.*, COUNT(posts.id) AS posts_count')
                        .left_joins(:posts)
                        .group('videos.id')
                        .order('posts_count DESC')
                        .limit(50)  # 必要なら増やしてね

    # 自分ランキング（ログイン時のみ）
    if user_signed_in?
      @my_rankings = Video.select('videos.*, COUNT(posts.id) AS my_posts_count')
                          .left_joins(:posts)
                          .where(posts: { user_id: current_user.id })
                          .group('videos.id')
                          .order('my_posts_count DESC')
                          .limit(50)
    else
      @my_rankings = []
    end
  end
end
