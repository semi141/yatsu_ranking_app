class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env["omniauth.auth"]
    Rails.logger.info auth.inspect
    @user = User.from_omniauth(auth)

    if @user.persisted?
      @user.update(
        token: auth.credentials.token,
        refresh_token: auth.credentials.refresh_token
      )

      sign_in @user, event: :authentication

      flash[:notice] = 'Googleアカウントで認証しました。' 
      
      # 記憶されたリダイレクト先があればそこへ、なければトップページへ飛ばす
      redirect_to stored_location_for(@user) || root_path

    else
      session["devise.google_data"] = auth.except("extra")
      redirect_to new_user_registration_url, alert: "Googleアカウントからユーザー情報を取得できませんでした"
    end
  end
end