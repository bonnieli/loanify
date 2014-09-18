class UserController < ActionController::Base
  layout 'application'
  before_action :authenticate_user! #checks if user is signed in
  
  def profile
    borrows = Transaction.find_by_id_b(current_user.id)
    lends = Transaction.find_by_id_l(current_user.id)

    if borrows == nil and lends == nil
      @empty = true
      @all_charts = [].to_json
    else
      @empty = false
      all_charts = {}

      #line chart - All
      res = Transaction.historygraph(current_user.id)
      all_charts.store('DebtLevel', JSON.parse(res))

      #pie chart - Debt
      res = Transaction.borrower_piechart(current_user.id)
      all_charts.store('Pie_d', JSON.parse(res))

      #pie chart - AR
      res = Transaction.lender_piechart(current_user.id)
      all_charts.store('Pie_ar', JSON.parse(res))

      #bubble chart - Debt
      res = Transaction.paidbackhistory(current_user.id)
      all_charts.store('History_d', JSON.parse(res))

      #bubble chart - AR
      #uri = URI('http://iou.azurewebsites.net/api/values/History/spaceholder/AR/' + session[:user])
      #res = Net::HTTP.get(uri)
      #all_charts.store('History_ar', JSON.parse(res))

      @all_charts = all_charts.to_json
    end

  end
end
