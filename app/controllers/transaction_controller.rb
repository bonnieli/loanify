class TransactionController < ActionController::Base
  layout 'application'
  protect_from_forgery with: :exception

  def create
    all_users = User.allusers.to_json
    unless all_users == '[]'
      @all_users = all_users
    end
  end

  def post
    transaction_info = {  'borrower_key' => params["BorrowerKey"].to_i,
                          'lender_key' => current_user.id,
                          'amount' => params["Amount"].to_f,
                          'date' => Time.parse(params["Date"]),
                          'description' => params["Description"] }

    @email_to = params["BorrowerEmail"]
    UserMailer.new_transaction(@email_to, transaction_info).deliver

    redirect_to home_url
  end

end
