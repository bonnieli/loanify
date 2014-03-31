class users < ActiveRecord::Base
	#add an user
	def add(input)
		user = Users.new
		user.fbnick = input[fbnick]
		user.profile_picture = input[profile_picture]
		user.fb_uniqueid = input[fb_uniqueid]
		user.first_name = input[first_name]
		user.last_name = input[last_name]
		user.token = input[token]
		user.expired = input[expired]
		user.expiry_date = input[expiry_date]
		user.date_joined = Time.new
		user.save
		return 1
	end
end