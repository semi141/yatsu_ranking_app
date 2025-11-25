class AddChannelIdToVideos < ActiveRecord::Migration[7.2]
  def change
    add_column :videos, :channel_id, :string
  end
end
