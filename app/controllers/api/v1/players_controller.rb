class Api::V1::PlayersController < Api::V1::ApiController

  skip_authorization_check

  def index
    @players = Player.all
    expose @players
  end

  def show
  	expose Player.where(id: params[:id]).includes(:team, :statistics), include: [:team, :statistics]
  end

end