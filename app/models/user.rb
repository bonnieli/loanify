class User < ActiveRecord::Base
	#add an user
	def self.newuser(input) #input must have all the fields
		user = User.new
		user.first_name = input["first_name"]
		user.last_name = input["last_name"]
		user.fb_uniqueid = input["fb_uniqueid"]
		user.token = input["token"]
		user.expired = false
		user.save
		return user
	end

	def self.emailcheck(input) #must be int, user must exist
		user = User.find(input)
		if user.email_address == nil
			return false
		else
			return true
		end
	end

	def self.addemail(input) # 2 elements, ID and email adderess
		user = User.find(input["id"])
		user.email_address = input["email_address"]
		user.save
		return user
	end

	def self.allusers(input)
		return Users.select("id, email_address, first_name, last_name, profile_picture")
	end
end