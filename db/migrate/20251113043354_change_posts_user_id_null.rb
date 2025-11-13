class ChangePostsUserIdNull < ActiveRecord::Migration[7.2]
  def change
    change_column_null :posts, :user_id, true  # user_id nil許容
    change_column_null :posts, :video_id, true  # video_id も同様に
  end
end