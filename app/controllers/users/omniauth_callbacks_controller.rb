class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    authentication = Authentication.find_by_provider_and_uid(auth_hash['provider'], auth_hash['uid'])

    if authentication 
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
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    # @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
 
    # if @user.persisted?
    #   sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
    #   set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    # else
    #   session["devise.facebook_data"] = request.env["omniauth.auth"]
    #   redirect_to new_user_registration_url
    # end

  end

  def auth_hash
    request.env["omniauth.auth"]
  end
end