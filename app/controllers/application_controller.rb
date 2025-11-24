class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  protect_from_forgery with: :exception

  # Deviseのデフォルトのログイン画面パス（/users/sign_in）をオーバーライドし、
  # 認証が必要になったら、直接Google認証のパスにリダイレクトさせるメソッド
  def new_session_path(scope)
    # :user スコープで :google_oauth2 プロバイダへの認証開始パスを返す
    return omniauth_authorize_path(:user, :google_oauth2)
  end
end