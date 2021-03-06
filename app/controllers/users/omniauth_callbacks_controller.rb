class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      auth = request.env["omniauth.auth"]
      @user.access_token = auth.credentials.token
      @user.expires_at = Time.at(auth.credentials.expires_at)
      @user.refresh_token = auth.credentials.refresh_token
      @user.save!
      sign_in(@user)
      redirect_to root_path
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
