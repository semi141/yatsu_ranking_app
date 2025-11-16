class Video < ApplicationRecord
  has_many :posts, dependent: :destroy
  validates :youtube_id, presence: true, uniqueness: true
end