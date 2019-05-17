class User < ApplicationRecord
	has_and_belongs_to_many :organizations
	has_many :facebook_pages, through: :organizations
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise	:database_authenticatable, :registerable,
			:recoverable, :rememberable, :validatable,
			:confirmable, :omniauthable, omniauth_providers: %i[facebook]

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

	def full_name
		"#{self.first_name} #{self.last_name}"
	end
end
