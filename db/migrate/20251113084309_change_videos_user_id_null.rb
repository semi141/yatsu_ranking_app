class ChangeVideosUserIdNull < ActiveRecord::Migration[7.2]
  def change
    change_column_null :videos, :user_id, true
  end
end
