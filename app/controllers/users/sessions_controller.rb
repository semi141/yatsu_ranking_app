class Users::SessionsController < Devise::SessionsController
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))

    if signed_out && is_navigational_format?

      flash[:notice] = t('devise.sessions.signed_out') 
    end
    # ----------------------------------------------------
    
    # 既存のログアウト後のリダイレクト処理
    yield resource if resource
    respond_to_on_destroy
  end

  protected

  def respond_to_on_destroy
    # ログアウト後のリダイレクト先
    redirect_to after_sign_out_path_for(resource_name)
  end
end