class GameController < ApplicationController

  DEFAULT_MAP_ROWS = 41
  DEFAULT_MAP_COLS = 41
  POWER_UPS_CHANCE = 5
  WALL_BORDER = "#"
  WALL_NON_DESTROYABLE = "="
  WALL_DESTROYABLE = "%"
  BOMB = "B"
  POWER_UPS_VISIBLE = "+"
  POWER_UPS_INVISIBLE = "-"
  EMPTY = " "

  def index
    generate_map(DEFAULT_MAP_ROWS, DEFAULT_MAP_COLS)

    puts @map
    # store map string to the database here

  end

  def perform_action
    # Values needed for broadcasting
    @lives_remaining = 0

    compute_lives

    if @lives_remaining > 0
      broadcast_out
    end

    puts "Game ID: #{@game_id}"
    puts "User ID: #{@user_id}"
    puts "Delta x: #{@delta_x}"
    puts "Delta y: #{@delta_y}"
    puts "Drop bomb: #{@dropped_bomb}"
    puts "Got killed: #{@got_killed}"
    puts "Pick up: #{@pick_up_power_up}"
    puts "Power up type: #{@power_up_type}"
    puts "Bricks: #{@destroyed_bricks}"

    render nothing: true
  end

  def broadcast_out
    puts "HI I GOT YOUR DATA"
     @gameid = params[:game_id]
     puts "GAME ID IS : @@@@ #{@gameid}"
     # Pusher.trigger('Test_channel3', 'my_event', {:movement => @game_movement})
  end

  private
  def generate_map(rows, cols)
    @map = ""

    (0...rows).each do |r|
      (0...cols).each do |c|

        # Create the border of the map
        if r == 0 || r == (rows - 1) || c == 0 || c == (cols - 1)
          @map << WALL_BORDER

        # Create non-destroyable walls
        elsif (r % 2 == 0) && (c % 2 == 0)
          @map << WALL_NON_DESTROYABLE

        # Randomly generate destroyable walls if it is not on the reserved locations
        elsif (2 < r && r < rows - 3) ||
              (2 < c && c < cols - 3)
          power_up = rand(100)

          if power_up < POWER_UPS_CHANCE
            @map << POWER_UPS_INVISIBLE
          else
            @map << (rand(100) < 50 ? WALL_DESTROYABLE : EMPTY)
          end

        else
          @map << EMPTY
        end
        # The rest of the locations are reserved for players to move
      end
      @map << "\n"
    end

  end

  def compute_lives
    user = params[:user]
    got_killed = user[:got_killed]

    current_lives = 1   # get this value from database

    if current_lives > 0 && got_killed
      current_lives = current_lives - 1
      @lives_remaining = current_lives

      # store current_lives back to database
    end
  end

end
