class Api::V1::PlayersController < Api::V1::ApiController

  skip_authorization_check

  def index
    @players = Player.all
    expose @players
  end

end