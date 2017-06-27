class TeamsController < ApplicationController

  load_and_authorize_resource

  def index
    @teams = Team.active
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.create(team_params)
    @teams = Team.active
  end

  def edit
  end

  def update
    @team.update_attributes(team_params)
  end

  def destroy
    @team.destroy
  end

  private
    def find_team
      @team = Team.find(params[:id])
    end

    def team_params
      params.require(:team).permit([:name, :second_name, :short_code, :acb_short_code, :rest_round_1, :rest_round_2, :playing_cup, :active])
    end
end