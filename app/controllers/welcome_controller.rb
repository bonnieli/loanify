require 'net/http'

class WelcomeController < ApplicationController
	skip_before_filter :verify_authenticity_token

  def index
    render :layout => false
  end

  def home
  	@user = session[:user_first_name] + ' ' + session[:user_last_name]
  end

  def create_transaction
    puts 'hihihihihihihi'
    uri = URI('http://iou.azurewebsites.net/api/values')
    name = Net::HTTP.get(uri)
    puts 'hi'
    unless name == '[]'
      @all_users = JSON.parse(name)
      puts @all_users
      puts 'test'
    end
  end

  def post_transaction
  	uri = URI('http://iou.azurewebsites.net/api/values')
  	puts params
  	transaction_info = { 'First_Name_B' => params["First_Name"],
  												'Last_Name_B' => params["Last_Name"],
  												'First_Name_L' => session[:user_first_name],
  												'Last_Name_L' => session[:user_last_name],
  												'BorrowerKey' => params["BorrowerKey"].to_i,
  												'LenderKey' => session[:user],
  												'Amount' => params["Amount"].to_f,
  												'Date' => Time.at(params["Date"].to_i),
  												'Description' => params["Description"],
  												'Type' => "transaction"
  											}
  	puts transaction_info
  	res = Net::HTTP.post_form(uri, 	transaction_info)
  	puts res.body

  	redirect_to welcome_home_url
  end

  def delete_transaction
  	http = Net::HTTP.new('iou.azurewebsites.net')
  	request = Net::HTTP::Delete.new('/api/values/' + params[:id])
  	response = http.request(request)
  	puts response

  	redirect_to welcome_uoi_url
  end

  def paidback
    uri = URI('http://iou.azurewebsites.net/api/values/')
    transaction_info = {'Type' => 'paidback', 
                        'ID' => params[:id]}
    res = Net::HTTP.post_form(uri,  transaction_info)

    redirect_to welcome_uoi_url
  end

  def reject
    uri = URI('http://iou.azurewebsites.net/api/values/')
    transaction_info = {'Type' => 'reject', 
                        'ID' => params[:id]}
    res = Net::HTTP.post_form(uri,  transaction_info)

    redirect_to welcome_iou_url
  end

  def iou
  	uri = URI('http://iou.azurewebsites.net/api/values/Borrower/' + session[:user])
  	res = Net::HTTP.get(uri)
  	unless res == '[]'
  		@transactions = JSON.parse(res)
  	end
  end

  def uoi
  	uri = URI('http://iou.azurewebsites.net/api/values/Lender/' + session[:user])
  	res = Net::HTTP.get(uri)
  	unless res == '[]'
  		@transactions = JSON.parse(res)
  	end
  end
end
