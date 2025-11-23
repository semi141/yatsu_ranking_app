# app/controllers/home_controller.rb

class HomeController < ApplicationController
  def ranking
    # ★ 期間設定を受け取る
    @tab = params[:tab] || "my"
    @period = params[:period] || "all" # 'all', 'weekly', 'monthly'
    
    # 期間に応じた Watch スコープを定義
    scoped_watches = Watch.within_period(@period)
    
    # --- 全体ランキング ---
    
    # 期間で絞り込んだ watches の視聴数を集計するサブクエリ
    all_watch_summary = scoped_watches.select('video_id, SUM(watched_count) as total_watches_count').group(:video_id)
    
    # Video をその集計データと結合してランキング
    @all_rankings = Video.joins(
      "INNER JOIN (#{all_watch_summary.to_sql}) AS filtered_watches 
       ON videos.id = filtered_watches.video_id"
    )
    .order('filtered_watches.total_watches_count DESC')
    .page(params[:page]) 
    .per(20)
    
    # --- 自分ランキング ---
    
    if user_signed_in?
      # 自分ランキングは、上記の期間スコープに加えて user_id も絞り込む
      my_watch_summary = scoped_watches
                           .where(user: current_user)
                           .select('video_id, SUM(watched_count) as user_watches_count')
                           .group(:video_id)
      
      @my_rankings = Video.joins(
        "INNER JOIN (#{my_watch_summary.to_sql}) AS user_filtered_watches 
         ON videos.id = user_filtered_watches.video_id"
      )
      .order('user_filtered_watches.user_watches_count DESC')
      .page(params[:page]) 
      .per(20)
    else
      @my_rankings = []
    end
  end
end