class Api::V1::PlayersController < Api::V1::ApiController

  skip_authorization_check

  def index
    @players = Player.all
    
    @players = @players.where(position: params[:position]) if params[:position].present?
    @players = @players.where(active: params[:active]) if params[:active].present?
    @players = @players.where("lower(players.name) ILIKE ?", "%#{params[:name].downcase}%") if params[:name].present?

    expose @players
  end

  def show
  	expose Player.where(id: params[:id]).includes(:team, :statistics), include: [:team, :statistics]
  end

end