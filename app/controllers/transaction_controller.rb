class TransactionController < ActionController::Base
  layout 'application'
  protect_from_forgery with: :exception

  def create
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

  def post
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
                          'Date' => Time.parse(params["Date"]),
                          'Description' => params["Description"],
                          'Type' => "transaction"
                        }

    res = Net::HTTP.post_form(uri,  transaction_info)

    @email_to = CGI.unescapeHTML(JSON.parse(res.body)["Email"])
    puts @email_to
    UserMailer.new_transaction(@email_to, transaction_info).deliver

    redirect_to home_url
  end

end
