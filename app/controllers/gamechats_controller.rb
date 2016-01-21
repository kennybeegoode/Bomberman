class GamechatsController < ApplicationController

  PUBLIC_CHAT_CHANNEL = "public_chat_channel"
  CHAT_MSG_RECEIVED_EVENT = "chat_msg_received_event"

  before_action :set_gamechat, only: [:show, :edit, :update, :destroy]

  before_filter :get_name
	require 'pusher'

	Pusher.app_id = 'insert id here'
  Pusher.key = 'insert pusher key here'
  Pusher.secret = 'insert pusher secret here'

  # GET /gamechats
  # GET /gamechats.json
  def index
    @gamechats = Gamechat.all
    @username = current_user.name
    @user_id = current_user[:id]
  end

  # GET /gamechats/1
  # GET /gamechats/1.json
  def show
  end

  # GET /gamechats/new
  def new
    @gamechat = Gamechat.new
  end

  # GET /gamechats/1/edit
  def edit
  end

  # POST /gamechats
  # POST /gamechats.json
  def create
    @gamechat = Gamechat.new(gamechat_params)

    respond_to do |format|
      if @gamechat.save
        format.html { redirect_to @gamechat, notice: 'Gamechat was successfully created.' }
        format.json { render :show, status: :created, location: @gamechat }
      else
        format.html { render :new }
        format.json { render json: @gamechat.errors, status: :unprocessable_entity }
      end
    end
  end

  def send_message

    data = {
      :name => @username,
      :message => params[:message],
      :sender_id => current_user[:id]
    }

    # Broadcast out to receivers
		Pusher.trigger(params[:channel_name], CHAT_MSG_RECEIVED_EVENT, data)

    render nothing: true

  end 
  def get_name
  	@username = current_user.name
  end

  # PATCH/PUT /gamechats/1
  # PATCH/PUT /gamechats/1.json
  def update
    respond_to do |format|
      if @gamechat.update(gamechat_params)
        format.html { redirect_to @gamechat, notice: 'Gamechat was successfully updated.' }
        format.json { render :show, status: :ok, location: @gamechat }
      else
        format.html { render :edit }
        format.json { render json: @gamechat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gamechats/1
  # DELETE /gamechats/1.json
  def destroy
    @gamechat.destroy
    respond_to do |format|
      format.html { redirect_to gamechats_url, notice: 'Gamechat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gamechat
      @gamechat = Gamechat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gamechat_params
      params.require(:gamechat).permit(:lobbyid, :message)
    end
end
