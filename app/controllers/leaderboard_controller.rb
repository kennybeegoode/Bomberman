class LeaderboardController < ApplicationController
  def index
  	#sorts the order of the users by their high_score attributes
  	@users = User.order(:high_score).reverse_order 
  end
end
