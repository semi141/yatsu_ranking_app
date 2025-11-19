class CreateWatches < ActiveRecord::Migration[7.2]
  def change
    create_table :watches do |t|
      t.references :user, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true
      t.integer :watched_count

      t.timestamps
    end
  end
end
