class Video < ApplicationRecord
  has_many :posts, dependent: :destroy
  belongs_to :user, optional: true
  validates :youtube_id, presence: true, uniqueness: true
  acts_as_taggable_on :tags

  # 全体のランキング
  def global_rank
    Video.all.order(watch_count: :desc).pluck(:id).index(self.id) + 1
  end

  # 自分のランキング
  def user_rank(user)
    rank_index = Video.where(user: user).order(watch_count: :desc).pluck(:id).index(self.id)
    rank_index ? rank_index + 1 : "ランクなし"
  end
end