class Watch < ApplicationRecord
  belongs_to :user
  belongs_to :video

  # 視聴回数は0じゃなくて1から始めたいからデフォルト値設定
  after_initialize :set_default_count, if: :new_record?

  private

  def set_default_count
    self.watched_count ||= 1
  end
end