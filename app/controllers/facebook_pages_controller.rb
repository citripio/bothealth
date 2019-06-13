class FacebookPagesController < ApplicationController
	before_action :authenticate_user!
	before_action :set_facebook_page, only: [:show, :edit, :manual_refresh, :update, :destroy]
	before_action :authorized?, only: [:show, :edit, :update, :destroy]

	# GET /facebook_pages
	# GET /facebook_pages.json
	def index
		if user_signed_in?
			@facebook_pages = current_user.facebook_pages
		else
			@facebook_pages = []
		end
	end

	def manual_refresh
		begin
			@facebook_page.fetch_raw_data
		rescue Koala::Facebook::AuthenticationError => e
			if e.fb_error_code === 190
				redirect_to omniauth_authorize_path(:user, :facebook, scope: "read_insights, pages_show_list")
				return
			end
		end
		redirect_to @facebook_page
	end

	# GET /facebook_pages/1
	# GET /facebook_pages/1.json
	def show
		@last_updated = @facebook_page.raw_total_messaging_connections.last.updated_at

		@start_date = !params[:start_date].blank? ? params[:start_date].to_date : Date.today - 14.days
		@end_date = !params[:end_date].blank? ? params[:end_date].to_date : Date.today
		if @start_date == @end_date
			flash[:notice] = "Start and End dates cannot be equal."
			normalize_invalid_date_range
			destroy_date_params
			redirect_to request.path, :params => params
		end
		if @start_date > @end_date
			flash[:alert] = "Start date cannot be more recent than End date."
			normalize_invalid_date_range
			destroy_date_params
			redirect_to request.path, :params => params
		end

		@sparklines_length = @facebook_page.format_for_chart(:raw_total_messaging_connections, :value, @start_date, @end_date).length / 12
		@sparklines_length = @sparklines_length > 0 ? @sparklines_length : 1

		@total_conversations = @facebook_page.total_conversations(@start_date, @end_date)
		@new_conversations = @facebook_page.new_conversations(@start_date, @end_date)
		@blocked_conversations = @facebook_page.blocked_conversations(@start_date, @end_date)
		@reported_conversations = @facebook_page.reported_conversations(@start_date, @end_date)
	end

	# GET /facebook_pages/new
	def new
		graph = Koala::Facebook::API.new(current_user.fb_access_token)
		me = graph.get_object("me")
		@fetched_pages = graph.get_object("me/accounts")

		@facebook_page = FacebookPage.new
		@facebook_page.organization = @current_organization
	end

	# GET /facebook_pages/1/edit
	def edit
	end

	# POST /facebook_pages
	# POST /facebook_pages.json
	def create
		@facebook_page = FacebookPage.new(facebook_page_params)

		respond_to do |format|
			if @facebook_page.save
				format.html { redirect_to @facebook_page, notice: 'Facebook page was successfully created.' }
				format.json { render :show, status: :created, location: @facebook_page }
			else
				format.html { render :new }
				format.json { render json: @facebook_page.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /facebook_pages/1
	# PATCH/PUT /facebook_pages/1.json
	def update
		respond_to do |format|
			if @facebook_page.update(facebook_page_params)
				format.html { redirect_to @facebook_page, notice: 'Facebook page was successfully updated.' }
				format.json { render :show, status: :ok, location: @facebook_page }
			else
				format.html { render :edit }
				format.json { render json: @facebook_page.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /facebook_pages/1
	# DELETE /facebook_pages/1.json
	def destroy
		@facebook_page.destroy
		respond_to do |format|
			format.html { redirect_to facebook_pages_url, notice: 'Facebook page was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		def destroy_date_params
			params.delete :start_date
			params.delete :end_date
		end
		def normalize_invalid_date_range
			@start_date = @end_date - 14.days
		end
		# Use callbacks to share common setup or constraints between actions.
		def set_facebook_page
			@facebook_page = FacebookPage.friendly.find(params[:id])
		end
		def authorized?
			if user_signed_in?
				if current_user.facebook_pages.pluck(:id).include? @facebook_page.id
					
				else
					raise ActionController::RoutingError.new('Not Found')
				end
			else
				redirect_to root_url
			end
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def facebook_page_params
			params.require(:facebook_page).permit(:name, :access_token, :organization_id)
		end
end
