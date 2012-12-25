class GamesController < ApplicationController
  def index
    @games = Dir.glob(Rails.root.join(*%w(app assets javascripts games *))).map do |game|
      game.match(/(\w+)(\.\w+)*$/)[1]
    end
  end

  def show
    @game = params[:id]
  end
end
