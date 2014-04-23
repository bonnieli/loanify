class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :omniauth_providers => [:facebook]
  has_many :authentications, :dependent => :delete_all
  validates_uniqueness_of :email_address

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def apply_omniauth(auth)
    #things stored in User
  	self.email_address = auth['extra']['raw_info']['email']
  	self.first_name = auth['extra']['raw_info']['first_name']
  	self.last_name = auth['extra']['raw_info']['last_name']
  	self.profile_picture = auth['info']['image']
    #link an Authentication model
  	authentications.build(:provider => auth['provider'],
  												:uid => auth['uid'],
  												:token => auth['credentials']['token'])
  end

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

	def self.allusers
		return User.select("id, email_address, first_name, last_name, profile_picture")
	end

	def self.user_fullname(input)
		user = User.find(input)
		return (user.first_name + " " + user.last_name)
	end

end