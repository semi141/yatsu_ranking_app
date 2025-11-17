class AddWatchCountToVideos < ActiveRecord::Migration[7.2]
  def change
    add_column :videos, :watch_count, :integer
  end
end
