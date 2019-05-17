class ApplicationController < ActionController::Base
	before_action :authenticate_user!
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

	protected

		def set_current_organization
			if user_signed_in?
				@current_organization = current_user.organizations.first
			end
		end

		def configure_permitted_parameters
			devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :first_name, :last_name, :email, :password, :password_confirmation)}
			devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :first_name, :last_name, :email, :password, :current_password)}
		end
end
