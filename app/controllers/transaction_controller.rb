class TransactionController < ActionController::Base
  layout 'application'
  protect_from_forgery with: :exception

  skip_before_action :verify_authenticity_token

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
                          'transaction_date' => Time.parse(params["Date"]),
                          'description' => params["Description"] }
    Transaction.newtransaction(transaction_info)

    @email_to = params["BorrowerEmail"]
    UserMailer.new_transaction(@email_to, transaction_info).deliver

    render :json => {"status" => 200}
  end

  def iou
    @transactions = Transaction.where(:id_b => current_user.id)
  end

  def uoi
    @transactions = Transaction.where(:id_l => current_user.id)
  end

  def delete
    Transaction.deletetransaction(params[:id])
    redirect_to transaction_uoi_url
  end

  def paidback
    if Transaction.paidback(params)
      render :nothing => true, :status => 200, :content_type => 'text/html', :json => {"status" => 200}
    else
      render :nothing => true, :status => 200, :content_type => 'text/html', :json => {"status" => 500}
    end
  end

end
