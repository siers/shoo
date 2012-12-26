class LinksController < WebsocketRails::BaseController
  cattr_accessor :games
  @@games = GameQueue.new

  def new
    games.type = message[:type]

    if (game = games.dequeue_game)
      puts 'Player found, play!'
    else
      game = games.new_game
      puts 'Waiting for players.'
    end
    self.current_game = game

    current_game.players << connection
    send_all('game.connected') unless game.new?
  end

  def ctcp
    send_others 'game.ctcp', message # That simple.
  end

  def reset
    send_others(:reset)
    games.type = current_game.type
    games.destroy_game(current_game)
    self.current_game = nil
  end

  private

  def puts(text)
    send_message 'console.puts', text
  end

  def current_game
    games.games[session[:game_id]]
  end

  def current_game=(game)
    session[:game_id] = game.id
  end

  def send_to_players(players, event, message = '')
    players.each do |player|
      send_message event, message, :connection => player
    end
  end

  def send_all(*args)
    send_to_players(current_game.players, *args)
  end

  def send_others(*args)
    send_to_players(current_game.players.-([connection]), *args)
  end
end
