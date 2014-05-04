class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user! #checks if user is signed in
  

  def index
		render :layout => false
	end

  def home 
  	@user = current_user
  end
end
