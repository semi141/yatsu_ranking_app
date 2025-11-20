class AddUniqueIndexToUsersEmail < ActiveRecord::Migration[7.0]
  def change
    # 既存の非ユニークindexを削除
    remove_index :users, :email if index_exists?(:users, :email)

    # ユニークindexを追加
    add_index :users, :email, unique: true
  end
end