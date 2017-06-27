# == Schema Information
#
# Table name: teams
#
#

class Team < ActiveRecord::Base
  # !**************************************************
  # !                Associations
  # !**************************************************
  has_many :players
  has_many :statistics

  # !**************************************************
  # !                Validations
  # !**************************************************

  # !**************************************************
  # !                Callbacks
  # !**************************************************

  # !**************************************************
  # !                  Other
  # !**************************************************  

  def to_s
    name
  end

  def self.active
    where(active: true)
  end

  def to_param
    [id.to_s, name.parameterize].join("-")
  end

  # !**************************************************
  # !                  Import
  # !**************************************************  
  def self.import_table
    table_url = Setting.find_by_key("table_url").value
    table_html = Nokogiri::HTML(open(table_url))

    i = 0
    table_html.css("table.resultados2 > tr").each do |game_row|
      if i > 0
        team_name = game_row.css('td[2]/a/text()').to_s
        if team = Team.where("name = ? OR second_name = ?", team_name, team_name).first
          team.position = game_row.css('td[1]//text()').to_s
          team.played = game_row.css('td[3]//text()').to_s
          team.won = game_row.css('td[4]//text()').to_s
          team.lost = game_row.css('td[5]//text()').to_s
          team.save!
        end
      end
      i = i + 1
    end
  end
end