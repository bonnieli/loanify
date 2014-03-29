class UserMailer < ActionMailer::Base
  default from: "bonnniel@gmail.com"
  def new_transaction(email)
  	@e = email
    mail(to: email, subject: 'You have a new transaction!')
  end
end
