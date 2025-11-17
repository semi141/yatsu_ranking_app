class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # 拡張機能用APIトークン
  before_create :generate_api_token

  has_many :posts, dependent: :destroy
  has_many :videos, through: :posts

  # Google OAuthでログイン/登録してきたときの処理
  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize
    user.email          ||= auth.info.email
    user.name           ||= auth.info.name
    user.password       ||= Devise.friendly_token[0, 20]
    user.access_token   = auth.credentials.token
    user.refresh_token  = auth.credentials.refresh_token if auth.credentials.refresh_token.present?

    # Googleログインでもapi_tokenが空なら生成する
    user.generate_api_token if user.api_token.blank?
    
    user.save!
    user
  end

  # トークン再生成用（ボタン押したとき用）
  def regenerate_api_token
    self.api_token = SecureRandom.hex(20)
    save!
  end

  private

  def generate_api_token
    loop do
      self.api_token = SecureRandom.hex(20)
      break unless User.exists?(api_token: self.api_token)
    end
  end
end