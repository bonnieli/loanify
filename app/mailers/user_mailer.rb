class UserMailer < ActionMailer::Base
  default from: "loanify@swaggerloo.ca"
  def new_transaction(email, info)
  	@e = email
  	@info = info
    mail(to: email, subject: 'You have a new transaction!')
  end

  def paidback(email)
  	mail(to: email, subject: 'You paidback a transaction!')
  end

  def reject(email)
  	mail(to: email, subject: 'You rejected a transaction!')
  end

  def rejected(email)
  	mail(to: email, subject: "You've been rejected!")
  end
end
