namespace :guest do
  desc "Deletes guest users who are older than 24 hours."
  task cleanup: :environment do
    # 削除対象の基準:
    # 1. guest: true のフラグが立っているユーザー
    # 2. 作成時刻 (created_at) が24時間以上前であるもの
    
    # 実行前に件数を確認
    count = User.where(guest: true)
                .where('created_at < ?', 1.day.ago)
                .count
                
    puts "ゲストユーザー削除処理を開始します..."
    
    # 削除実行
    # ここで destroy_all を使うと、Userモデルに設定されている dependent: :destroy 
    # (視聴記録やコメントも一緒に削除する設定) が働き、関連データも安全に削除
    User.where(guest: true)
        .where('created_at < ?', 1.day.ago)
        .destroy_all
        
    puts "✅ 処理が完了しました: #{count} 件の古いゲストユーザーが削除されました。"
  end
end