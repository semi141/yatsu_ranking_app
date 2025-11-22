class HomeController < ApplicationController
  def ranking
    @tab = params[:tab] || "my"

    # 全体ランキング (ページネーションを適用)
    @all_rankings = Video.left_joins(:watches)
                           .page(params[:page]) # ページネーションを追加
                           .per(20)              # 1ページあたり20件に制限
                           .group('videos.id')
                           .select('videos.*, COUNT(watches.id) AS total_watches_count')
                           .order(Arel.sql('SUM(COALESCE(watches.watched_count, 0)) DESC'))

    # 自分ランキング (ページネーションを適用)
    if user_signed_in?
      @my_rankings = Video.left_joins(:watches)
                            .where(watches: { user_id: current_user.id })
                            .page(params[:page]) # ページネーションを追加
                            .per(20)             # 1ページあたり20件に制限
                            .group('videos.id')
                            .select('videos.*')
                            .order(Arel.sql('MAX(COALESCE(watches.watched_count, 0)) DESC'))
    else
      @my_rankings = []
    end
  end
end