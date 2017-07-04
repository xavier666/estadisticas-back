# == Schema Information
#
# Table name: players
#
#

class PlayerSerializer < EstadisticasSerializer

  belongs_to :team, serializer: TeamSerializer
  has_many :statistics, serializer: StatisticSerializer

  attributes :name, :position, :height, :weithg, :date_of_birth, :place_of_birth, :image, :number, :price

end