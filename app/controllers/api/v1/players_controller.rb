class Api::V1::PlayersController < Api::V1::ApiController

  def index
    @players = Player.all
    expose @players
  end

end