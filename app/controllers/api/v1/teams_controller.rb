class Api::V1::TeamsController < Api::V1::ApiController

  def index
    @teams = Team.all
    expose @teams
  end

end