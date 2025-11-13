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

      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      session["devise.google_data"] = auth.except("extra")
      redirect_to new_user_registration_url, alert: "Googleアカウントからユーザー情報を取得できませんでした"
    end
  end
end
