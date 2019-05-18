class User < ApplicationRecord
	has_and_belongs_to_many :organizations
	has_many :facebook_pages, through: :organizations
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise	:database_authenticatable, :registerable,
			:recoverable, :rememberable, :validatable,
			:confirmable, :omniauthable, omniauth_providers: %i[facebook]
	attr_accessor :optional_invitation

	def self.from_omniauth(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
			user.email = auth.info.email
			user.password = Devise.friendly_token[0, 20]
			user.first_name = auth.info.first_name
			user.last_name = auth.info.last_name
			user.fb_access_token = auth.credentials.token
			# user.avatar = auth.info.image # assuming the user model has an image
			# If you are using confirmable and the provider(s) you use validate emails, 
			# uncomment the line below to skip the confirmation emails.
			user.skip_confirmation!
		end
	end

	def self.new_with_session(params, session)
		super.tap do |user|
			if credentials = session["devise.facebook_data"] && session["devise.facebook_data"]["credentials"]
				user.fb_access_token = credentials["token"] if user.fb_access_token.blank?
			end
		end
	end

	def profile_pic_url
		# include MD5 gem, should be part of standard ruby install
		require 'digest/md5'

		if self.provider == "facebook"
			return "http://graph.facebook.com/v2.10/#{self.uid}/picture?type=large"
		elsif self.avatar?
			return "#{PROJECT_WEBSITE}#{self.avatar.url}"
		else
			# create the md5 hash
			hash = Digest::MD5.hexdigest(self.email)
			# compile URL which can be used in <img src="RIGHT_HERE"...
			return "https://www.gravatar.com/avatar/#{hash}"
		end
	end

	def full_name
		if self.first_name.nil?
			self.email
		else
			"#{self.first_name} #{self.last_name}"
		end
	end
end
