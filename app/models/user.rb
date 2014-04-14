class User < ActiveRecord::Base
	#add an user
	def self.newuser(input)
		user = User.new
		user.first_name = input["first_name"]
		user.last_name = input["last_name"]
		user.fb_uniqueid = input["fb_uniqueid"]
		user.token = input["token"]
		user.expired = false
		user.email_address = input["email_address"]
		return user
	end
end