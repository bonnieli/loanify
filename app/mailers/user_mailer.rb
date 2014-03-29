class UserMailer < ActionMailer::Base
  default from: "loanify@swaggerloo.ca"
  def new_transaction(email, info)
  	@e = email
  	@info = info
    mail(to: email, subject: 'You have a new transaction!')
  end
end
