class Watch < ApplicationRecord
  belongs_to :user
  belongs_to :video

  after_initialize :set_default_count, if: :new_record?

  # 過去 N 日間の視聴記録を絞り込むスコープ
  scope :within_period, ->(period) do
    case period
    when 'weekly'
      # 過去7日間 (created_at)
      where(created_at: 7.days.ago..Time.zone.now)
    when 'monthly'
      # 過去30日間 (created_at)
      where(created_at: 30.days.ago..Time.zone.now)
    else
      all # 'all' (総合) または指定がない場合は全てを返す
    end
  end

  private

  def set_default_count
    self.watched_count ||= 1
  end
end