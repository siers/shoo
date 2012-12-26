require 'ostruct'

class Game < OpenStruct
  def initialize(hash)
    super({:players => []}.merge(hash))
  end

  def inspect
    "#<Game:#{ object_id.<<(1).to_s(16) } @player.count=#{ players.count }>"
  end

  def new?
    players.count == 1
  end
end
