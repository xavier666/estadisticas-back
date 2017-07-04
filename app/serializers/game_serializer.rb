# == Schema Information
#
# Table name: games
#
#

class GameSerializer < EstadisticasSerializer

  belongs_to :local_team, class_name: "Team", serializer: TeamSerializer
  belongs_to :away_team, class_name: "Team", serializer: TeamSerializer

  attributes :local_team_id, :away_team_id, :season, :round, :game_date, :local_score, :away_score, :first_second_game

end