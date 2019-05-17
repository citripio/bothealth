class FacebookPagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_facebook_page, only: [:show, :edit, :update, :destroy]

  # GET /facebook_pages
  # GET /facebook_pages.json
  def index
    @facebook_pages = FacebookPage.all
  end

  # GET /facebook_pages/1
  # GET /facebook_pages/1.json
  def show
    page_graph = Koala::Facebook::API.new(@facebook_page.access_token)
    since = (Time.now - 1.month).to_i
    metric = %w(
      page_messages_total_messaging_connections
      page_messages_new_conversations_unique
      page_messages_blocked_conversations_unique
      page_messages_reported_conversations_unique
      page_messages_feedback_by_action_unique
    )
    @insights = page_graph.get_object("me/insights?metric=#{metric.join(",")}&since=#{since}")
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
    # Use callbacks to share common setup or constraints between actions.
    def set_facebook_page
      @facebook_page = FacebookPage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def facebook_page_params
      params.require(:facebook_page).permit(:name, :access_token, :organization_id)
    end
end
