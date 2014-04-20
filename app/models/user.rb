class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :omniauth_providers => [:facebook]
  has_many :authentications, :dependent => :delete_all
  validates_uniqueness_of :email_address

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def apply_omniauth(auth)
  	self.email_address = auth['extra']['raw_info']['email']
  	self.first_name = auth['extra']['raw_info']['first_name']
  	self.last_name = auth['extra']['raw_info']['last_name']
  	self.profile_picture = auth['info']['image']
  	authentications.build(:provider => auth['provider'],
  												:uid => auth['uid'],
  												:token => auth['credentials']['token'])
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(name:auth.extra.raw_info.name,
                            provider:auth.provider,
                            uid:auth.uid,
                            email:auth.info.email,
                            password:Devise.friendly_token[0,20]
                          )
      end
       
    end
  end

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