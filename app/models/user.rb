class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable,
        :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize
    user.email = auth.info.email
    user.name = auth.info.name
    user.password ||= Devise.friendly_token[0, 20]  # すでにパスワードがあれば上書きしない
    user.access_token = auth.credentials.token
    user.refresh_token = auth.credentials.refresh_token if auth.credentials.refresh_token.present?
    user.save!
    user
  end
end
