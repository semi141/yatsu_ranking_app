GUEST_USER_EMAIL = "guest@example.com"

class Users::GuestLoginsController < ApplicationController
  # ログイン状態でも実行できるように
  before_action :authenticate_user!, except: [:create]

  # ゲストログイン処理
  def create
    
    # ゲストユーザーを見つける
    user = User.find_by!(email: GUEST_USER_EMAIL)
    
    # ユーザーをログインさせる (Deviseのヘルパーメソッド)
    sign_in user 
    
    # ログイン後のページにリダイレクト
    redirect_to root_path, notice: "ゲストユーザーとしてログインしました！"
  end
end