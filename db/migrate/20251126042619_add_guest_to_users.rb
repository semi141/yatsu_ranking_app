class AddGuestToUsers < ActiveRecord::Migration[6.0]
  def change
    # null: false と default: false を設定して、必須かつデフォルト値を通常ユーザーにする
    add_column :users, :guest, :boolean, default: false, null: false
  end
end