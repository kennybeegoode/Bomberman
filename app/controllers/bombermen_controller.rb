class BombermenController < ApplicationController

  PLAYER_LEFT_EVENT = "player_left_event"
  GAME_STARTED_EVENT = "game_started_event"
  PLAYER_MOVED_EVENT = "playerMoved"

  before_action :set_bomberman, only: [:show, :edit, :update, :destroy]

  # GET /bombermen
  # GET /bombermen.json
  def index
    @bombermen = Bomberman.find_or_create_by(lobby_id: params[:lobbyid])
  end

  # GET /bombermen/1
  # GET /bombermen/1.json
  def show

    # Find the game record
    @bomberman = Bomberman.find(params[:id])
    users = @bomberman[:user_list]

    # Redirect user to root page if the player does not have authorize to
    # access it
    if users.nil?
      redirect_to "/"
      return
    end

    unless users.include? current_user[:id].to_s
      redirect_to "/"
      return
    end

    user_emails = User.find_emails(@bomberman[:user_list])

    # Include user emails
    @data = {
      id: @bomberman[:id],
      game_name: @bomberman[:game_name],
      channel_name: @bomberman[:channel_name],
      lobby_id: @bomberman[:lobby_id],
      selected_map: @bomberman[:selected_map],
      user_ids: @bomberman[:user_list],
      user_emails: user_emails
    }

    respond_to do |format|
      format.html { render :show }
      format.json { @data }
    end

  end

  # GET /bombermen/new
  def new
    @bomberman = Bomberman.new
  end

  # GET /bombermen/1/edit
  def edit
  end

  # POST /bombermen
  # POST /bombermen.json
  def create
    @bomberman = Bomberman.new(bomberman_params)

    if @bomberman.save
      broadcast(params[:channel_name], GAME_STARTED_EVENT, { game_id: @bomberman[:id] })

      # Do not need to show anything, let the gamelobby.js handle it
      render status: :ok, nothing: true

    else
      render status: :unprocessable_entity, nothing: true
    end
  end

  # PATCH/PUT /bombermen/1
  # PATCH/PUT /bombermen/1.json
  def update
    respond_to do |format|
      if @bomberman.update(bomberman_params)
        format.html { redirect_to @bomberman, notice: 'Bomberman was successfully updated.' }
        format.json { render :show, status: :ok, location: @bomberman }
      else
        format.html { render :edit }
        format.json { render json: @bomberman.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bombermen/1
  # DELETE /bombermen/1.json
  def destroy
    @bomberman.destroy

    render nothing: true
  end

  def broadcast_out

  	@game_movement = params

    @userid = params[:user][:id]
    @x = params[:user][:x]
    @y = params[:user][:y]

    channel_name = params[:channel_name]

    puts "UserID = #{@userid}"
    puts "x = #{@x}"
    puts "y = #{@y}"

    Pusher.trigger(channel_name, PLAYER_MOVED_EVENT, {:movement => @game_movement})
    render nothing: true
  end

  def add_user
    @bomberman = Bomberman.where(lobby_id: params[:lobbyid]).first
    @bomberman.user_list << params[:username]
    #puts "ADASADASDSDADSADSAD\n\n\n\n\n\n#{bomberman.id}"
    if @bomberman.save
      render nothing: true
    else
      render json: @bomberman.errors, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    redirect_to "/"

  end

  def get_users
    @bomberman = Bomberman.where(lobby_id: params[:lobbyid]).first
    puts "@@@@@@@@@\n\n#{@bomberman} OR #{params[:lobbyid]}"
    unless @bomberman.nil?
      render json: @bomberman
    else
      render json: @bomberman.errors
    end

  rescue ActiveRecord::RecordNotFound
    redirect_to "/"

  end

  def set_winner
    user = User.find(params[:id])
    unless user.nil?
      user[:high_score] = user[:high_score] + 1
      user.save
    end
    render nothing: true
  end

  def get_game
    id = params[:id]

    @bomberman = Bomberman.find(id)
    users = @bomberman[:user_list]

    # Redirect user to root page if the player does not have authorize to
    # access it
    if users.nil?
      redirect_to "/"
      return
    end

    unless users.include? current_user[:id].to_s
      redirect_to "/"
      return
    end

    user_emails = User.find_emails(@bomberman[:user_list])

    # Return data in a map
    data = {
      id: id,
      game_name: @bomberman[:game_name],
      channel_name: @bomberman[:channel_name],
      lobby_id: @bomberman[:lobby_id],
      user_ids: @bomberman[:user_list],
      user_emails: user_emails
    }

    render json: data, status: :ok, nothing: true

  rescue ActiveRecord::RecordNotFound
    redirect_to "/"

  end

  def leave

    id = params[:id]
    leaver_id = params[:user_id]

    @bomberman = Bomberman.find(id)

    @bomberman[:user_list].delete leaver_id.to_s

    @bomberman.save

    if @bomberman[:user_list].length <= 0
      destroy
    end

    render nothing: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bomberman
      @bomberman = Bomberman.find(params[:id])

    rescue ActiveRecord::RecordNotFound
      redirect_to "/"

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bomberman_params
      {
        lobby_id: params[:lobby_id],
        game_name: params[:game_name],
        channel_name: params[:channel_name],
        selected_map: params[:selected_map],
        user_list: params[:user_list]
      }
    end

  def broadcast(channels, event, data)
    # Include the socket ID because we want to exclude the sender as the recipient
    Pusher.trigger(channels, event, data, { socket_id: params[:socket_id] });
  end

end
