# == Schema Information
#
# Table name: games
#
#
require 'nokogiri'
require 'open-uri'
require 'webrick/httputils'
require 'date'

class Game < ActiveRecord::Base
  # !**************************************************
  # !                Associations
  # !**************************************************
  belongs_to :local_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"

  # !**************************************************
  # !                Validations
  # !**************************************************

  # !**************************************************
  # !                Callbacks
  # !**************************************************

  # !**************************************************
  # !                  Other
  # !**************************************************  
  default_scope { order("games.round::integer ASC").order(game_date: :asc) }
  scope :by_season, -> (season) { where(:season => season) }
  scope :by_round,  -> (round)  { where(:round  => round) }

  def self.active
    where(active: true)
  end

  def to_param
    [id.to_s, local_team.name.parameterize, away_team.name.parameterize].join("-")
  end

  # !**************************************************
  # !                Imports
  # !**************************************************
  def self.import_games
    games_url = Setting.find_by_key("games_url").value
    games_html = Nokogiri::HTML(open(games_url.to_s))
    num_game = 0

    games_html.css("table.menuclubs > tr").each do |game_row|
      teams = game_row.css('td[2]//text()').to_s
      date_score = game_row.css('td[3]//text()').to_s
      array_teams = teams.split(" - ")
      local = Team.find_by_name(array_teams[0])
      away = Team.find_by_name(array_teams[1])

      if local and away 
        game = Game.where(local_team_id: local.id).where(away_team_id: away.id).first
        unless game
          game = Game.new
          game.local_team_id = local.id
          game.away_team_id = away.id
          
          unless date_score.include? ' - '
            game.game_date = !date_score.blank? ? DateTime.parse(date_score) : ""
          end
        end

        # Sate - Result
        if date_score.include? ' - '
          array_score = date_score.split(" - ")
          game.local_score = array_score[0]
          game.away_score = array_score[1]
        end

        game.season = CURRENT_SEASON
        game.round = (num_game / 8) + 1
        game.save!
      end
      num_game += 1
    end
  end

  def self.import_game game
    games_url = game.href
    games_url.force_encoding('binary')
    games_url = WEBrick::HTTPUtils.escape(games_url)
    game_html = Nokogiri::HTML(open(games_url))

    game_html.css("td.fichaJugadorData").each do |game_data|
      position_detail = game_data.css('p[2]//text()').to_s
      height = game_data.css('p[3]/strong[1]/text()').to_s
      date_of_birth = game_data.css('p[5]/strong[1]/text()').to_s
      place_of_birth = game_data.css('p[5]/strong[2]/text()').to_s
      
      position_detail = position_detail
      height = height
      date_of_birth = date_of_birth
      place_of_birth = place_of_birth
    end
    game_html.css("td.fichaJugadorimg").each do |game_image|
      image = Array.wrap(game_image.css("img").map { |link| link['src'] })[0].to_s
      image = image
    end
    save!
  end
end