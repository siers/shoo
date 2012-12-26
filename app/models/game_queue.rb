class GameQueue
  attr_accessor :games, :queues, :type

  # All games go to the @games pool, each game type has it's own queue.

  def initialize
    @games  = {}
    @queues = Hash.new { |hash, key| hash[key] = [] }
  end

  def new_game
    id = games.hash
    games[id] ||= Game.new(id: id, type: type)
    queues[type] << id
    games[id]
  end

  def dequeue_game
    id = queues[type].shift
    games[id]
  end

  def destroy_game(game)
    queues[type].delete(game.id)
    games.delete(game.id)
  end
end
