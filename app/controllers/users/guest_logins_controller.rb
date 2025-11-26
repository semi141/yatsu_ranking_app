class Users::GuestLoginsController < ApplicationController
  # ログイン状態でも実行できるようにする
  before_action :authenticate_user!, except: [:create]

  # ゲストログイン処理
  def create
    # db/seeds.rb で定義したゲストユーザーのメールアドレス
    GUEST_USER_EMAIL = "guest@example.com"

    # 1. ゲストユーザーを見つける
    user = User.find_by!(email: GUEST_USER_EMAIL)
    
    # 2. ユーザーをログインさせる (Deviseのヘルパーメソッド)
    sign_in user 
    
    # 3. ログイン後のページにリダイレクト
    redirect_to root_path, notice: "ゲストユーザーとしてログインしました！"
  end
end