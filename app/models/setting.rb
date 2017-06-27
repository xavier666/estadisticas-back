# == Schema Information
#
# Table name: settings
#
#  id                :integer          not null, primary key
#  name              :string
#  key               :string
#  value             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  values            :jsonb            default({})
#

class Setting < ActiveRecord::Base
  # !**************************************************
  # !                Associations
  # !**************************************************

  # !**************************************************
  # !                Validations
  # !**************************************************
  validates_presence_of :value
  validates_uniqueness_of :key, :name

  # !**************************************************
  # !                Callbacks
  # !**************************************************

  # !**************************************************
  # !                  Other
  # !**************************************************

end
