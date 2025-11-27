class HomeController < ApplicationController
  # チャンネルIDを定数として定義
  JARUTOWER_ID = "UChwgNUWPM-ksOP3BbfQHS5Q"
  JARAISLAND_ID = "UCf-wG6PlxW7rpixx1tmODJw"

  # 1ページあたりの表示件数を定数として定義
  PER_PAGE = 20

  def ranking
  @tab = params[:tab]

  if @tab.blank?
    # ログアウト時: デフォルトを「全体ランキング」にする
    if !user_signed_in?
      @tab = "all"
    # ログイン時: デフォルトを「自分ランキング」にする
    else
      @tab = "my"
    end
  end
  
  @period = params[:period] || "all" # 'all', 'weekly', 'monthly'
  
  # ページネーション用の計算
  # 現在のページ番号を取得し、1未満なら1ページ目をデフォルトとする
  @current_page = params[:page].to_i < 1 ? 1 : params[:page].to_i
  # データを取得し始める位置（オフセット）を計算
  offset_value = (@current_page - 1) * PER_PAGE

  # 期間に応じた Watch スコープを定義
  scoped_watches = Watch.within_period(@period)

  # チャンネル絞り込み用のベースクエリ定義
  video_base_query = Video.all
  case params[:channel]
  when 'tower'
    video_base_query = video_base_query.where(channel_id: JARUTOWER_ID)
    @title_prefix = "ジャルジャルタワー限定 "
  when 'island'
    video_base_query = video_base_query.where(channel_id: JARAISLAND_ID)
    @title_prefix = "ジャルジャルアイランド限定 "
  else
    @title_prefix = ""
  end
  @title = @title_prefix + "動画ランキング"
  
  # 全体ランキング
  
  # 期間で絞り込んだ watches の視聴数を集計するサブクエリ
  all_watch_summary = scoped_watches.select('video_id, SUM(watched_count) as total_watches_count').group(:video_id)
  
  # Video をその集計データと結合してランキング
  # 一旦クエリとして保存（まだデータは取得しない）
  @all_rankings_query = video_base_query.joins(
    "INNER JOIN (#{all_watch_summary.to_sql}) AS filtered_watches 
      ON videos.id = filtered_watches.video_id"
  )
  .order('filtered_watches.total_watches_count DESC')

  # 総件数を取得して、総ページ数を計算
  @all_total_count = @all_rankings_query.count
  @all_total_pages = (@all_total_count.to_f / PER_PAGE).ceil

  # ページネーション適用（LIMITとOFFSETを使用）
  @all_rankings = @all_rankings_query.limit(PER_PAGE).offset(offset_value)
    
    # 自分ランキング
    
    if user_signed_in?

      if current_user.api_token.blank?
        # トークンがない場合
        @my_rankings = []
        @my_total_count = 0
        @my_total_pages = 0
      else
        # トークンがある場合のみ、ランキングを取得する
        my_scoped_watches = scoped_watches.where(user: current_user)
        
        my_watch_summary = my_scoped_watches
                             .select('video_id, SUM(watched_count) as user_watches_count')
                             .group(:video_id)
        
        # 一旦クエリとして保存
        @my_rankings_query = video_base_query.joins(
          "INNER JOIN (#{my_watch_summary.to_sql}) AS user_filtered_watches 
           ON videos.id = user_filtered_watches.video_id"
        )
        .order('user_filtered_watches.user_watches_count DESC')

        # 総件数を取得して、総ページ数を計算
        @my_total_count = @my_rankings_query.count
        @my_total_pages = (@my_total_count.to_f / PER_PAGE).ceil
        
        # ページネーション適用
        @my_rankings = @my_rankings_query.limit(PER_PAGE).offset(offset_value)
      end
      
    else
      @my_rankings = []
      @my_total_count = 0
      @my_total_pages = 0
    end
  end
end