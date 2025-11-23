class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def regenerate_token
    current_user.regenerate_api_token
    redirect_back(fallback_location: root_path, notice: "トークンを再生成しました！拡張機能の設定も更新してね！")
  end
end