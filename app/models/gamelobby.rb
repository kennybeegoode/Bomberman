class Gamelobby < ActiveRecord::Base

  # Overriding the usual way of setting db column.
  def userlist=(val)
    super(Array(val))
  end
end
