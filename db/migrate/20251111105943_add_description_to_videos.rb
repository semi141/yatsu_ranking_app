class AddDescriptionToVideos < ActiveRecord::Migration[7.2]
  def change
    add_column :videos, :description, :text
  end
end
