class GamelobbiesController < ApplicationController

  MAX_INT = 9999999
  MAX_USERS_PER_ROOM = 4

  # List of channels
  # Individual game lobby will have its channel generated dynamically and will
  # be stored as lobby_id in the database record
  GAME_LOBBIES_PUBLIC_CHANNEL = "game_lobbies_channel"

  # List of events
  LOBBIES_UPDATED_EVENT = "lobbies_updated_event"
  GAME_ROOM_UPDATED_EVENT = "game_room_updated_event"
  GAME_STARTED_EVENT = "game_started_event"

  before_action :set_gamelobby, only: [:show, :edit, :update, :destroy]

  # GET /gamelobbies
  # GET /gamelobbies.json
  def index
    @gamelobbies = Gamelobby.where("? < user_count AND user_count < ? AND game_started = ?", 0, MAX_USERS_PER_ROOM, false)
                     .order("user_count DESC")
  end

  def join_with_link

    id = params[:id]

    flash[:lobby_id] = "#{id}"

    respond_to do |format|
      format.html { redirect_to "/" }
      format.json { render :index, status: :ok, location: @gamelobby }
    end

  rescue ActiveRecord::RecordNotFound
    redirect_to "/"

  end

  # POST /gamelobbies/join
  def join

    # Get the corresponding game lobby
    id = params[:id]
    @gamelobby = Gamelobby.find(id)

    unless @gamelobby.nil? || @gamelobby[:user_list].length >= 4

      # Update the user count and list of users
      @gamelobby[:user_list] << current_user[:id]
      @gamelobby[:user_count] = @gamelobby[:user_list].length

      if @gamelobby.save
        broadcast(@gamelobby[:lobby_id], GAME_ROOM_UPDATED_EVENT, { :current_user_id => current_user[:id].to_s })
        broadcast(GAME_LOBBIES_PUBLIC_CHANNEL, LOBBIES_UPDATED_EVENT, {})

        # Store current user to the object
        data = {
          :current_user_id => current_user[:id].to_s,
          :channel_name => @gamelobby[:lobby_id]
        }
        render json: data, status: :ok, location: @gamelobby

      else
        render json: data.errors, status: :unprocessable_entity

      end

    else
      # This will gets rendered when the room is full, which may happend
      # when 2 or more users clicked on the same "join" button at the same time
      respond_to do |format|
        format.html { redirect_to "/", notice: 'The room is full!' }
        format.json { render :index, status: :unprocessable_entity}
      end
    end
  end

  # POST /gamelobbies/leave
  def leave

    # Get the corresponding game lobby
    id = params[:id]
    @gamelobby = Gamelobby.find(id)

    unless @gamelobby.nil?

      # Update the user count and list of users
      @gamelobby[:user_list].delete(current_user[:id].to_s)
      @gamelobby[:user_count] = @gamelobby[:user_list].length

      if @gamelobby.save

        # If there is no more user in the room, then delete the room
        if @gamelobby[:user_count] <= 0
          destroy
        else
          # Keep the room in the table if more users is in the room
          broadcast(@gamelobby[:lobby_id], GAME_ROOM_UPDATED_EVENT, { :current_user_id => current_user[:id].to_s })
          broadcast(GAME_LOBBIES_PUBLIC_CHANNEL, LOBBIES_UPDATED_EVENT, {})

          render json: @gamelobby, status: :created, nothing: true
        end

      else
        render json: @gamelobby.errors, status: :unprocessable_entity

      end

    else
      render json: @gamelobby.errors, status: :unprocessable_entity
    end
  end

  # POST /gamelobbies/changethumbnail
  def change_thumbnail

    user_id = params[:user_id]

    if current_user[:id].to_s == user_id.to_s

      # Find the User
      user = User.find(user_id.to_s)

      # Change the image path
      user[:image] = params[:image]

      if user.save
        data = { :current_user_id => current_user[:id].to_s }

        # Broadcast out
        broadcast(params[:channel_name], GAME_ROOM_UPDATED_EVENT, data)
        broadcast(GAME_LOBBIES_PUBLIC_CHANNEL, LOBBIES_UPDATED_EVENT, {})
      end

    end

    render nothing: true
  end

  def update_map

    id = params[:id]
    gamelobby = Gamelobby.find(id)

    old_map_id = gamelobby[:selected_map]

    # Make sure only the host can update the map
    unless gamelobby.nil?

      users = gamelobby[:user_list]

      if current_user[:id].to_s == users[0].to_s

        gamelobby[:selected_map] = params[:selected_map]

        if gamelobby.save

          broadcast(gamelobby[:lobby_id], GAME_ROOM_UPDATED_EVENT, { :current_user_id => current_user[:id].to_s } )

          render nothing: true
          return
        end
      end
    end

    # Reset back to old map ID because failed to update
    gamelobby[:selected_map] = old_map_id
    gamelobby.save

    render nothing: true
  end

  # POST /gamelobbies/channelname/start/1
  def start_game
    # Get the corresponding game lobby ID
    id = params[:id]
    @gamelobby = Gamelobby.find(id)

    unless @gamelobby.nil?

      users = @gamelobby[:user_list]

      # Make sure we only start the game if there are more than 1 persons
      # in the game room
      if users.length > 1

        # Make sure the person who start this game is the host
        host = users[0]
        if host.to_s == current_user[:id].to_s

          render json: { lobby_id: @gamelobby[:id],
                         game_name: @gamelobby[:lobby_name],
                         channel_name: @gamelobby[:lobby_id],
                         selected_map: @gamelobby[:selected_map],
                         user_list: @gamelobby[:user_list] },
                 status: :ok,
                 nothing: true

          return
        end
      end
    end

    render nothing: true
  end

  # GET /gamelobbies/channelname/1
  def get_channel_name

    # Get the corresponding game lobby
    id = params[:id]

    @gamelobby = Gamelobby.find(id)

    unless @gamelobby.nil?
      render json: { channel_name: @gamelobby[:lobby_id] }, status: :ok, nothing: true

    else
      render status: :unauthorized, nothing: true
    end
  end

  # GET /gamelobbies/1
  # GET /gamelobbies/1.json
  def show
  end

  # GET /gamelobbies/new
  def new
    @gamelobby = Gamelobby.new
  end

  # GET /gamelobbies/1/edit
  def edit
  end

  # POST /gamelobbies
  # POST /gamelobbies.json
  def create
    @gamelobby = Gamelobby.new(gamelobby_params)

    if @gamelobby.save
      broadcast(GAME_LOBBIES_PUBLIC_CHANNEL, LOBBIES_UPDATED_EVENT, {})

      render json: @gamelobby, status: :created, location: @gamelobby

    else
      render json: @gamelobby.errors, status: :unprocessable_entity

    end
  end

  # PATCH/PUT /gamelobbies/1
  # PATCH/PUT /gamelobbies/1.json
  def update
    respond_to do |format|
      if @gamelobby.update(gamelobby_params)
        broadcast(GAME_LOBBIES_PUBLIC_CHANNEL, LOBBIES_UPDATED_EVENT, {})

        format.html { redirect_to @gamelobby, notice: 'Gamelobby was successfully updated.' }
        format.json { render :show, status: :ok, location: @gamelobby }
      else
        format.html { render :edit }
        format.json { render json: @gamelobby.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gamelobbies/1
  # DELETE /gamelobbies/1.json
  def destroy
    begin
      @gamelobby.destroy

      broadcast(GAME_LOBBIES_PUBLIC_CHANNEL, LOBBIES_UPDATED_EVENT, {})

    rescue ActiveRecord::RecordNotFound
      # it's all good
    end

    render nothing: true

  end

  def show_room
    @show_room
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_gamelobby
    @gamelobby = Gamelobby.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def gamelobby_params
    # Preset some parameter values
    {
      lobby_id: new_lobby_id,
      lobby_name: params[:name],
      public: params[:public],
      game_started: false,
      user_count: 1,
      user_list: [current_user[:id]]
    }
  end

  def new_lobby_id
    # Get the current time in miliseconds and hexadecimal format
    time = (Time.zone.now.to_f * 1000).to_i
    time_in_hex = time.to_s(16)

    # Get a random number in hexadecimal format
    rand_int = rand(MAX_INT)
    rand_int_in_hex = rand_int.to_s(16)

    # Combine both current time and random number to use as the lobby ID
    (time_in_hex + rand_int_in_hex).upcase
  end

  def broadcast(channels, event, data)
    # Include the socket ID because we want to exclude the sender as the recipient
    Pusher.trigger(channels, event, data, { socket_id: params[:socket_id] });
  end
end
