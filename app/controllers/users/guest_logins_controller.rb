class Users::GuestLoginsController < ApplicationController
  # ゲストユーザー作成とログイン処理
  def create
    # ユーザーを新規作成し、ゲストフラグとランダムなメールアドレスを設定
    # `find_or_create_by!` の代わりに `new` と `save!` を使うことで、アクセスごとに新しいゲストを作成
    user = User.new(
      email: SecureRandom.uuid + "@guest.local", # ゲスト専用のメールアドレス
      password: SecureRandom.urlsafe_base64,     # ランダムなパスワード
      guest: true                                # ゲストユーザーであるフラグ
    )
    
    # ユーザーの保存
    if user.save
      # 作成したユーザーでログインさせる (Deviseのヘルパーメソッド)
      sign_in user 
      redirect_to root_path, notice: "ゲストユーザーとしてログインしました！データはセッション終了後にリセットされます。"
    else
      # ユーザー作成失敗時
      redirect_to root_path, alert: "ゲストログインに失敗しました。"
    end
  end
end