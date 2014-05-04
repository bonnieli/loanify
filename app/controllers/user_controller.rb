class UserController < ActionController::Base
  layout 'application'
  before_action :authenticate_user! #checks if user is signed in
  
  def profile
    all_charts = {}

   # uri = URI('http://iou.azurewebsites.net/api/values/' + session[:user])
   # res = Net::HTTP.get(uri)
   # all_charts.store('Stat', JSON.parse(res))

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
    puts "@all_charts"
    puts @all_charts
  end
end
