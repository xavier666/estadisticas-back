class Api::V1::TeamsController < Api::V1::ApiController

  skip_authorization_check

  def index
    @teams = Team.all
    expose @teams, include: [players: :statistics]
  end

  def show
  	expose Team.where(id: params[:id]).includes(players: :statistics), include: [players: :statistics]
  end

end