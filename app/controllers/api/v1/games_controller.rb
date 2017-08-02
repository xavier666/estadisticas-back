class Api::V1::GamesController < Api::V1::ApiController

  skip_authorization_check

  def index
  	params[:season] = CURRENT_SEASON
  	params[:round] = CURRENT_ROUND.to_i - 1

  	@games = Game.all
  	
  	@games = @games.where(:season => params[:season]) if params[:season]
    @games = @games.where(:round => params[:round]) if params[:round]

    expose @games  
  end

  def show
  	expose Game.where(id: params[:id]).includes(local_team: [players: :statistics], away_team: [players: :statistics]), include: [local_team: [players: :statistics], away_team: [players: :statistics]]
  end

  def calendar
    @games = Game.includes(:local_team, :away_team).by_season(CURRENT_SEASON).order(:round)
    expose @games, include: [:local_team, :away_team]
  end

  private

    def game_params
      params.require(:game).permit([:id, :name, :short_code, :season, :round, :active])
    end

end