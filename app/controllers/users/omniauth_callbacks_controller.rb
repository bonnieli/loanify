class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    authentication = Authentication.find_by_provider_and_uid(auth_hash['provider'], auth_hash['uid'])

    if authentication
      if authentication.expired_date == nil || Time.now > authentication.expired_date
        authentication.expired_date = Time.at(auth_hash['credentials']['expires_at'])
        authentication.token = auth_hash['credentials']['token']
        authentication.save
      end 
      flash[:notice]
      sign_in_and_redirect(:user, authentication.user)
    else
      user = User.new
      user.apply_omniauth(auth_hash)
      if user.save(:validate => false)
        flash[:notice] = "Account created and signed in successfully"
        sign_in_and_redirect(:user, user)
      else
        flash[:error] = "Error when creating user account"
        redirect_to root_url
      end
    end

  end

  def auth_hash
    request.env["omniauth.auth"]
  end
end