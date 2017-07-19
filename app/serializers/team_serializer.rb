# == Schema Information
#
# Table name: teams
#
#

class TeamSerializer < EstadisticasSerializer

  has_many :players, serializer: PlayerSerializer
  has_many :games, serializer: GameSerializer

  attributes :name, :short_code, :position, :played, :won, :lost, :rest_round_1, :rest_round_2, :playing_cup, :played_games

end