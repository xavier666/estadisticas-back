class Api::V1::GamesController < Api::V1::ApiController

  def index
    @games = Game.all
    expose @games
  end

end