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
    uri = URI('http://iou.azurewebsites.net/api/values')
    all_users = Net::HTTP.get(uri)
    unless all_users == '[]'
      @all_users = all_users
    end
    currency_uri = URI('http://iou.azurewebsites.net/api/values/Currency')
    all_currencies = Net::HTTP.get(currency_uri)
    unless all_currencies == '[]'
      @all_currencies = JSON.parse(all_currencies)
    end
  end

  def post_transaction
  	uri = URI('http://iou.azurewebsites.net/api/values')
  	transaction_info = { 'First_Name_B' => params["Name"].split.at(0),
  												'Last_Name_B' => params["Name"].split.at(1),
  												'First_Name_L' => session[:user_first_name],
  												'Last_Name_L' => session[:user_last_name],
  												'BorrowerKey' => params["BorrowerKey"].to_i,
                          'BPicture' => params["B_Picture"],
                          'LPicture' => session[:user_pic],
  												'LenderKey' => session[:user].to_i,
  												'Amount' => params["Amount"].to_f,
                          'Currency_Name' => params["Currency_Name"],
                          # 'Currency_Symbol' => params["Currency_Symbol"],
                          'Date' => Time.parse(params["Date"]),
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

  def profile
    @all_charts = {}

    #bubble graph
    #profile_info = {'graphtype' => 'History', 'split' => 'AR', 'id' => session[:user]}

    #line chart - Debt
    uri = URI('http://iou.azurewebsites.net/api/values/DebtLevel/spaceholder/Debt/' + session[:user])
    res = Net::HTTP.get(uri)
    unless res == '[]'
      @all_charts.store('DebtLevel_d', res)
    end
    #line chart - AR
    uri = URI('http://iou.azurewebsites.net/api/values/DebtLevel/spaceholder/AR/' + session[:user])
    res = Net::HTTP.get(uri)
    unless res == '[]'
      @all_charts.store('DebtLevel_ar', res)
    end

    puts "@all_charts"
    puts @all_charts
  end
end
