require 'net/http'

class SessionsController < ApplicationController
	def create
    authentication = Authentication.find_by_provider_and_uid(auth_hash['provider'], auth_hash['uid'])
 
    if authentication 
      flash[:notice]
      sign_in_and_redirect(:user, authentication.user)
    else
      user = User.new
      user.apply_omniauth(auth_hash)
      if user.save(:validate => false)
        flash[:notice] = "Account created and signed in successfully"
        sign_in(:user, user)
        redirect_to welcome_home_url
      else
        flash[:error] = "Error when creating user account"
        redirect_to root_url
      end
    end

    # uri = URI('http://iou.azurewebsites.net/api/values')
    # fb_info = {'Token' => auth_hash['credentials']['token'],
        #         'Expirey_date' => auth_hash['credentials']['expires_at'],
        #         'FBNick' => auth_hash['info']['nickname'],
        #         'FBID' => auth_hash['extra']['raw_info']['id'],
        #         'First_Name' => auth_hash['extra']['raw_info']['first_name'],
        #         'Last_Name' => auth_hash['extra']['raw_info']['last_name'],
        #         'Picture' => auth_hash['info']['image'],
        #         'Type' => "user"}
    # res = Net::HTTP.post_form(uri,  fb_info)
    # @user =  res.body # should return user ID
    # session[:user] = @user 

    # session[:user_first_name] = auth_hash['extra']['raw_info']['first_name']
    # session[:user_last_name] = auth_hash['extra']['raw_info']['last_name']

    # redirect_to welcome_home_url
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
