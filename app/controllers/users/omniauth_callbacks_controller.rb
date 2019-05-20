# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def facebook
		# You need to implement the method below in your model (e.g. app/models/user.rb)
		@user = User.from_omniauth(request.env["omniauth.auth"])

		if @user.persisted?
			# sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
			sign_in @user, event: :authentication #this will throw if @user is not activated
			set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
			# redirect_to new_facebook_page_path
			accept_invitation
			create_facebook_pages
			redirect_to "/"
		else
			session["devise.facebook_data"] = request.env["omniauth.auth"]
			redirect_to new_user_registration_url
		end
	end

	def accept_invitation
		if !request.env["omniauth.params"]["optional_invitation"].nil?
			invitation = request.env["omniauth.params"]["optional_invitation"]
			org = Organization.find_by(id: Organization.decode_id(invitation)[0].to_i)
			if !org.nil?
				@user.organizations << org
				flash[:notice] << " You've been added to the \"#{org.title}\" organization."
			end
		end
	end

	def create_facebook_pages
		graph = Koala::Facebook::API.new(@user.fb_access_token)
	    me = graph.get_object("me")
		fetched_pages = graph.get_object("me/accounts")
		fetched_pages.each do |page|
			if !FacebookPage.exists?(identifier: page["id"])
				if !@current_organization.nil?
					@current_organization.facebook_pages.create(
						identifier: page["id"], 
						name: page["name"], 
						access_token: page["access_token"],
						user_id: @user.id,
					)
				end
			end
		end
	end

	def failure
		redirect_to root_path
	end
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
