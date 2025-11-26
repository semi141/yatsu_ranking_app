class Users::RegistrationsController < Devise::RegistrationsController
  # ゲストユーザーのアカウント情報変更・退会を禁止する
  # update (情報更新), destroy (退会) の前にチェックを行う
  before_action :check_guest, only: [:edit, :update, :destroy]

  # ゲストチェックのロジック
  def check_guest
    # current_user は Devise のヘルパーメソッド
    if current_user.guest?
      redirect_to root_path, alert: "ゲストユーザーは情報の変更・アカウントの削除はできません。"
    end
  end
end