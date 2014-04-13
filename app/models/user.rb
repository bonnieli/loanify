class User < ActiveRecord::Base
	#add an user
	def self.iou(input)
		user = User.new
		user.first_name = input["first_name"]
		return Transaction.where("id_b = 1")
	end
end