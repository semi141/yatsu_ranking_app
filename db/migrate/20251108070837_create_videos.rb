class CreateVideos < ActiveRecord::Migration[7.2]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :url
      t.string :category
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
