class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  protect_from_forgery with: :exception

  def new_session_path(scope)
    return omniauth_authorize_path(:user, :google_oauth2)
  end

  # ログイン（サインイン）後のリダイレクト先を制御する
  def after_sign_in_path_for(resource)
    stored_location = stored_location_for(resource)
    if stored_location.present?
      return stored_location
    end

    if request.referer.present? && request.referer != new_user_session_url
      return request.referer
    end

    super(resource)
  end
end