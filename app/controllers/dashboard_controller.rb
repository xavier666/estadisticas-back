class DashboardController < ApplicationController

  skip_authorization_check

  def index
    @games = Game.by_season(CURRENT_SEASON).by_round(CURRENT_ROUND)
  end

  private
    def dashboard_params
    end

end