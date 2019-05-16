class ApplicationController < ActionController::Base
	before_action :authenticate_user!
	
	def index
		if user_signed_in?
			graph = Koala::Facebook::API.new(current_user.fb_access_token)
			me = graph.get_object("me")
			accts = graph.get_object("me/accounts")
			@insights = []
			accts.each do |page|
				page_graph = Koala::Facebook::API.new(page["access_token"])
				since = (Time.now - 1.month).to_i
				page_name = page["name"]
				page_insights = page_graph.get_object("me/insights?metric=page_messages_total_messaging_connections,page_messages_new_conversations_unique,page_messages_blocked_conversations_unique,page_messages_reported_conversations_unique,page_messages_feedback_by_action_unique&since=#{since}")
				@insights << {page_name: page_name, page_insights: page_insights}
			end
		end		
	end

	before_action :configure_permitted_parameters, if: :devise_controller?

	protected
		def configure_permitted_parameters
			devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :first_name, :last_name, :email, :password, :password_confirmation)}
			devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :first_name, :last_name, :email, :password, :current_password)}
		end
end
