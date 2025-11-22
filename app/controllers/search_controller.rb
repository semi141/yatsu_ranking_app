# app/controllers/search_controller.rb

class SearchController < ApplicationController
  def index
    # 初期状態として全ての動画を取得
    @videos = Video.all
    
    # 検索ロジックをここに入れる！
    @videos = @videos.tagged_with(params[:tag]) if params[:tag].present?
    @videos = @videos.where("title LIKE ?", "%#{params[:keyword]}%") if params[:keyword].present?
    
    # ソートロジック
    case params[:sort]
    when "desc"
      @videos = @videos.order(watch_count: :desc)
    when "asc"
      @videos = @videos.order(watch_count: :asc)
    else
      @videos = @videos.order(watch_count: :desc) # デフォルトは多い順
    end

    # indexアクションで検索結果を表示する場合、特に何もrenderしない（index.html.erbが使われる）

    # ★トップページから来たときに検索結果ページを表示するための条件分岐（後述）
    if params[:keyword].present? || params[:tag].present? || params[:sort].present?
        render :results # パラメータがあれば results.html.erb を表示
    else
        # パラメータがなければ検索フォーム (index.html.erb) を表示
        # 何も書かなければ index.html.erb が自動で使われる
    end

  end
  
  # resultsアクションは不要になるので削除推奨
  # def results
  # end
end