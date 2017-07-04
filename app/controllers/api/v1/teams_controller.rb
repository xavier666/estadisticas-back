class Api::V1::TeamsController < Api::V1::ApiController

  skip_authorization_check

  def index
    @teams = Team.all
    expose @teams
  end

end