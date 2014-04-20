class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def index
		session[:email_check] = false
		session[:user] = nil
		session[:user_first_name] = nil
		session[:user_last_name] = nil
		session[:user_pic] = nil
		render :layout => false
	end

  def home 
  	@user = current_user
  end
end
