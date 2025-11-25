# frozen_string_literal: true

namespace :db do
  desc 'Fixes incorrect UTC timestamps for Comment model by adding 9 hours (JST diff)'
  task fix_comment_timestamps: :environment do
    # UTCとJSTの時差（9時間）を秒単位で定義
    time_diff_seconds = 9 * 60 * 60

    puts '== コメント時刻の修正を開始します =='

    # コメントモデルの存在を確認
    unless defined?(Comment)
      puts 'エラー: Commentモデルが見つかりません。'
      exit
    end

    # 全てのコメントを取得し、トランザクション内で安全に更新
    ActiveRecord::Base.transaction do
      Comment.find_each do |comment|
        # created_at と updated_at に9時間を加算
        new_created_at = comment.created_at + time_diff_seconds.seconds
        new_updated_at = comment.updated_at + time_diff_seconds.seconds

        # update_columnsでバリデーションとコールバックをスキップし、高速に更新
        comment.update_columns(created_at: new_created_at, updated_at: new_updated_at)

        print '.'
      end
    end

    puts "\n== 全コメントの時刻修正が完了しました =="
  rescue StandardError => e
    puts "\nエラーが発生しました: #{e.message}"
    puts 'トランザクションがロールバックされました。'
  end
end