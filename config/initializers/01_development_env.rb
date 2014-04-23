if Rails.env.development? || Rails.env.production?
	#fb omniauth
  ENV['FB_APP_ID'] = "1390894531173876"
  ENV['FB_SECRET'] = "3a11e6b74ab83671fe6014174cec2442"

  #mail settings for production only
  ENV['MAIL_ADDRESS'] = "smtp.1and1.com"
  ENV['MAIL_PORT'] = "25"
  ENV['MAIL_AUTHENTICATION'] = "plain"
  ENV['MAIL_USER_NAME'] = "loanify@swaggerloo.ca"
  ENV['MAIL_PSWD'] = "AbC123$" 

end