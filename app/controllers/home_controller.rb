class HomeController < ApplicationController
  def ranking
    @tab = params[:tab] || "my"

    # 全体ランキング
    @all_rankings = Video.left_joins(:watches)
                         .group('videos.id')
                         .select('videos.*, COUNT(watches.id) AS total_watches_count')
                         .order(Arel.sql('SUM(COALESCE(watches.watched_count, 0)) DESC'))
                         .limit(50)

    # 自分ランキング
    if user_signed_in?
      @my_rankings = Video.left_joins(:watches)
                            .where(watches: { user_id: current_user.id })
                            .group('videos.id')
                            .select('videos.*')
                            .order(Arel.sql('MAX(COALESCE(watches.watched_count, 0)) DESC'))
                            .limit(50)
    else
      @my_rankings = []
    end
  end
end
