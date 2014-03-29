require 'net/http'

class SessionsController < ApplicationController
	def create
    uri = URI('http://iou.azurewebsites.net/api/values')
    fb_info = {'Token' => auth_hash['credentials']['token'],
								'Expirey_date' => auth_hash['credentials']['expires_at'],
								'FBNick' => auth_hash['info']['nickname'],
								'FBID' => auth_hash['extra']['raw_info']['id'],
								'First_Name' => auth_hash['extra']['raw_info']['first_name'],
								'Last_Name' => auth_hash['extra']['raw_info']['last_name'],
								'Picture' => auth_hash['info']['image'],
								'Type' => "user"}

    res = Net::HTTP.post_form(uri, 	fb_info)
    @user =  JSON.parse(res.body)["ID"] # should return user ID
    session[:email_check] = JSON.parse(res.body)["BoolCheck"]

    session[:user] = @user.to_s

    session[:user_first_name] = auth_hash['extra']['raw_info']['first_name']
    session[:user_last_name] = auth_hash['extra']['raw_info']['last_name']
    session[:user_pic] = auth_hash['info']['image']

    redirect_to welcome_home_url
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
