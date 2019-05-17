class ApplicationController < ActionController::Base
	before_action :authenticate_user!, except: [:invitation]
	before_action :set_current_organization
	before_action :configure_permitted_parameters, if: :devise_controller?
	
	def index
		if user_signed_in?
			if @current_organization.nil?
				flash[:notice] = "You don't belong to any organization. Get invited or add a new one."
				redirect_to new_organization_path
			else
				redirect_to @current_organization
			end
		end		
	end

	def invitation
		if !params[:invitation_hash].nil?
			invitation = params[:invitation_hash]
			org = Organization.find_by(id: Organization.decode_id(invitation)[0].to_i)
			if !org.nil?
				if user_signed_in?
					current_user.organizations << org
					redirect_to url_for(org)
				else
					redurl = url_for(new_registration_path(:user, invitation: org.encoded_id))
					redirect_to redurl
				end
			end
		end
	end

	protected

		def set_current_organization
			if user_signed_in?
				@current_organization = current_user.organizations.first
			end
		end

		def configure_permitted_parameters
			devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :first_name, :last_name, :email, :password, :password_confirmation, :optional_invitation)}
			devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :first_name, :last_name, :email, :password, :current_password)}
		end
end
