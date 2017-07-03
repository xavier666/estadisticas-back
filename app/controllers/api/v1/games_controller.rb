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
  	expose Game.where(id: params[:id])
  end

  private

    def game_params
      params.require(:game).permit([:name, :short_code, :season, :round, :active])
    end

end