require 'net/http'

class WelcomeController < ApplicationController
	skip_before_filter :verify_authenticity_token

  def email
    e = params[:email]
    uri = URI('http://iou.azurewebsites.net/api/values')
    email_info = {'Type' => 'email',
               'ID' => session[:user],
               'Email' => e }

    res = Net::HTTP.post_form(uri,  email_info)
    session[:email_check] = true
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
                        'ID' => params[:id],
                        'DatePaidBack' => Time.parse(params[:d])}
    res = Net::HTTP.post_form(uri,  transaction_info)

    if (JSON.parse(res.body)["BoolCheck"])
      UserMailer.paidback(CGI.unescapeHTML(JSON.parse(res.body)["Email"])).deliver
      redirect_to welcome_uoi_url
    else 
      redirect_to welcome_paidback_error_url
    end  
  end

  def pb_error

  end

  def reject
    uri = URI('http://iou.azurewebsites.net/api/values/')
    transaction_info = {'Type' => 'reject', 
                        'ID' => params[:id]}
    res = Net::HTTP.post_form(uri,  transaction_info)
    puts res.body
    UserMailer.rejected(CGI.unescapeHTML(JSON.parse(res.body)["Email"])).deliver
    redirect_to welcome_iou_url
  end

  def iou
    @status = "all"
  	uri = URI('http://iou.azurewebsites.net/api/values/Borrower/' + session[:user])
  	res = Net::HTTP.get(uri)
  	unless res == '[]'
  		@transactions = JSON.parse(res)
  	end
  end

  def iou_rejected
    @status = "rejected"
    uri = URI('http://iou.azurewebsites.net/api/values/Borrower/Rejected/' + session[:user])
    res = Net::HTTP.get(uri)
    unless res == '[]'
      @transactions = JSON.parse(res)
    end
    render :iou
  end

  def iou_paid
    @status = "paid"
    uri = URI('http://iou.azurewebsites.net/api/values/Borrower/Paidback/' + session[:user])
    res = Net::HTTP.get(uri)
    unless res == '[]'
      @transactions = JSON.parse(res)
    end
    render :iou
  end

  def iou_unpaid
    @status = "unpaid"
    uri = URI('http://iou.azurewebsites.net/api/values/Borrower/Unpaid/' + session[:user])
    res = Net::HTTP.get(uri)
    unless res == '[]'
      @transactions = JSON.parse(res)
    end
    render :iou
  end

  def uoi
    @status = "all"
  	uri = URI('http://iou.azurewebsites.net/api/values/Lender/' + session[:user])
  	res = Net::HTTP.get(uri)
  	unless res == '[]'
  		@transactions = JSON.parse(res)
  	end
  end

  def uoi_rejected
    @status = "rejected"
    uri = URI('http://iou.azurewebsites.net/api/values/Lender/Rejected/' + session[:user])
    res = Net::HTTP.get(uri)
    unless res == '[]'
      @transactions = JSON.parse(res)
    end
    render :uoi
  end

  def uoi_paid
    @status = "paid"
    uri = URI('http://iou.azurewebsites.net/api/values/Lender/Paidback/' + session[:user])
    res = Net::HTTP.get(uri)
    unless res == '[]'
      @transactions = JSON.parse(res)
    end
    render :uoi
  end

  def uoi_unpaid
    @status = "unpaid"
    uri = URI('http://iou.azurewebsites.net/api/values/Lender/Unpaid/' + session[:user])
    res = Net::HTTP.get(uri)
    unless res == '[]'
      @transactions = JSON.parse(res)
    end
    render :uoi
  end

  def profile
    all_charts = {}

    uri = URI('http://iou.azurewebsites.net/api/values/' + session[:user])
    res = Net::HTTP.get(uri)
    all_charts.store('Stat', JSON.parse(res))

    #line chart - Debt
    uri = URI('http://iou.azurewebsites.net/api/values/DebtLevel/spaceholder/Debt/' + session[:user])
    res = Net::HTTP.get(uri)
    all_charts.store('DebtLevel_d', JSON.parse(res))

    #line chart - AR
    uri = URI('http://iou.azurewebsites.net/api/values/DebtLevel/spaceholder/AR/' + session[:user])
    res = Net::HTTP.get(uri)
    all_charts.store('DebtLevel_ar', JSON.parse(res))

    #pie chart - Debt
    uri = URI('http://iou.azurewebsites.net/api/values/Pie/spaceholder/Debt/' + session[:user])
    res = Net::HTTP.get(uri)
    all_charts.store('Pie_d', JSON.parse(res))

    #pie chart - AR
    uri = URI('http://iou.azurewebsites.net/api/values/Pie/spaceholder/AR/' + session[:user])
    res = Net::HTTP.get(uri)
    all_charts.store('Pie_ar', JSON.parse(res))

    #bubble chart - Debt
    uri = URI('http://iou.azurewebsites.net/api/values/History/spaceholder/Debt/' + session[:user])
    res = Net::HTTP.get(uri)
    all_charts.store('History_d', JSON.parse(res))

    #bubble chart - AR
    uri = URI('http://iou.azurewebsites.net/api/values/History/spaceholder/AR/' + session[:user])
    res = Net::HTTP.get(uri)
    all_charts.store('History_ar', JSON.parse(res))

    @all_charts = all_charts.to_json
    puts "@all_charts"
    puts @all_charts
  end
end
