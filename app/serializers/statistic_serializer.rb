# == Schema Information
#
# Table name: statistics
#
#

class StatisticSerializer < ActiveModel::Serializer

  belongs_to :player, serializer: PlayerSerializer

  attributes :season, 	:week_1,  :week_2,  :week_3,  :week_4,  :week_5,  :week_6,  :week_7,  :week_8,  :week_9,  :week_10, 
  						:week_11, :week_12, :week_13, :week_14, :week_15, :week_16, :week_17, :week_18, :week_19, :week_20, 
  						:week_21, :week_22, :week_23, :week_24, :week_25, :week_26, :week_27, :week_28, :week_29, :week_30, 
						:week_31, :week_32, :week_33, :week_34, :promedio, :total
end