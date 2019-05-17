class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
		# You need to implement the method below in your model (e.g. app/models/user.rb)
		@user = User.from_omniauth(request.env["omniauth.auth"])

		if @user.persisted?
			# sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
			sign_in @user, event: :authentication #this will throw if @user is not activated
			set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
			# redirect_to new_facebook_page_path
			create_facebook_pages
			redirect_to "/"
		else
			session["devise.facebook_data"] = request.env["omniauth.auth"]
			redirect_to new_user_registration_url
		end
	end

	def create_facebook_pages
		graph = Koala::Facebook::API.new(@user.fb_access_token)
	    me = graph.get_object("me")
		fetched_pages = graph.get_object("me/accounts")
		fetched_pages.each do |page|
			if !FacebookPage.exists?(identifier: page["id"])
				logger.info("DID NOT EXIST")
				# FacebookPage.create(
				@current_organization.facebook_pages.create(
					identifier: page["id"], 
					name: page["name"], 
					access_token: page["access_token"]
				)
			end
		end
	end

	def failure
		redirect_to root_path
	end
end