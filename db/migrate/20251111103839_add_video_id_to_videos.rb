class AddVideoIdToVideos < ActiveRecord::Migration[7.2]
  def change
    add_column :videos, :video_id, :string
    add_index :videos, :video_id
  end
end
