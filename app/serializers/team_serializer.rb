# == Schema Information
#
# Table name: teams
#
#

class TeamSerializer < EstadisticasSerializer

  has_many :players, serializer: PlayerSerializer
  has_many :games, serializer: GameSerializer

  attributes :name

end