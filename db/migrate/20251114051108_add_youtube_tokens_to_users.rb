class AddYoutubeTokensToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :youtube_token, :string
    add_column :users, :youtube_refresh_token, :string
    add_column :users, :youtube_expires_at, :datetime
  end
end
