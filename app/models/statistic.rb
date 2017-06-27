# == Schema Information
#
# Table name: statistics
#
#

class Statistic < ActiveRecord::Base
  
  FIELDS = %w( game min pt t2 t3 t1 reb a br bp c tap m fp fr mas_menos v sm )  
  FIELDS_DEFAULT = ["-", "0'", "0", "0/0", "0/0", "0/0", "0(0+0)", "0", "0", "0", "0", "0+0", "0", "0", "0", "0", "0", "0.00" ]  

  NUM_GAMES = Setting.find_by_key("session_rounds").value.to_i

  # !**************************************************
  # !                Associations
  # !**************************************************
  belongs_to :player

  # !**************************************************
  # !                Validations
  # !**************************************************

  # !**************************************************
  # !                Callbacks
  # !**************************************************
  #before_save :set_defaults

  # !**************************************************
  # !                  Other
  # !**************************************************  
  include StatisticAllowed
  scope :by_season, -> (season) { where(:season => season).first }
  scope :by_round,  -> (round)  { where(:round  => round).first }
  
  def to_s
    season + " - " + player.to_s
  end

  def self.num_games
    NUM_GAMES.to_i
  end

  def self.fields
    FIELDS
  end

  # !**************************************************
  # !                Imports
  # !**************************************************
  def self.import_statistics
    players_url = Setting.find_by_key("statistics_url").value
    players_html = Nokogiri::HTML(open(players_url.to_s))

    players_html.css("table.listaJugadores > tr").each do |player_row|
      name = player_row.css('td[1]//text()').to_s
      team_name = player_row.css('td[2]/text()').to_s

      unless name.blank?
        if player = Player.find_by_name(name)
          player.href = Array.wrap(player_row.css("td[1]/a").map { |link| link['href'] })[0].to_s
          import_statistic player
        end
      end
    end
  end

  def self.import_statistic player
    players_url = player.href
    players_url.force_encoding('binary')
    players_url = WEBrick::HTTPUtils.escape(players_url)
    player_html = Nokogiri::HTML(open(players_url))

    current_season = CURRENT_SEASON

    unless statistic = Statistic.where(season: current_season).where(player_id: player.id).first
      statistic = Statistic.new
      statistic.season = current_season
      statistic.player_id = player.id
      statistic.save!
    end

    session_rounds = Setting.find_by_key("session_rounds").value

    statistic.played_games = 0
    player_html.css("table.fichaJugadorStats > tr").each do |row_statistic|
      partido = row_statistic.css("th[1]/text()").to_s.downcase
      if partido == 'promedio' || partido == 'total' || (1..session_rounds.to_i).include?(partido.to_i)
        if (1..session_rounds.to_i).include?(partido.to_i)
          partido = "week_"+partido 
          plus = 0
        else
          plus = 1
        end
        game = row_statistic.css("td["+(2-plus).to_s+"]/text()")
        minutos = row_statistic.css("td["+(3-plus).to_s+"]/text()")
        puntos = row_statistic.css("td["+(4-plus).to_s+"]/text()")
        t2 = row_statistic.css("td["+(5-plus).to_s+"]/text()")
        t3 = row_statistic.css("td["+(7-plus).to_s+"]/text()")
        t1 = row_statistic.css("td["+(9-plus).to_s+"]/text()")
        reb = row_statistic.css("td["+(11-plus).to_s+"]/text()")
        a = row_statistic.css("td["+(12-plus).to_s+"]/text()")
        br = row_statistic.css("td["+(13-plus).to_s+"]/text()")
        bp = row_statistic.css("td["+(14-plus).to_s+"]/text()")
        c = row_statistic.css("td["+(15-plus).to_s+"]/text()")
        tap = row_statistic.css("td["+(16-plus).to_s+"]/text()")
        m = row_statistic.css("td["+(17-plus).to_s+"]/text()")
        fp = row_statistic.css("td["+(18-plus).to_s+"]/text()")
        fr = row_statistic.css("td["+(19-plus).to_s+"]/text()")
        mas_menos = row_statistic.css("td["+(20-plus).to_s+"]/text()")
        v = row_statistic.css("td["+(21-plus).to_s+"]/text()")
        sm = row_statistic.css("td["+(22-plus).to_s+"]/text()")

        values = {
          game: game.to_s,
          min: minutos.to_s,      pt: puntos.to_s,          t2: t2.to_s, 
          t3: t3.to_s,            t1: t1.to_s,              reb: reb.to_s,
          a: a.to_s,              br: br.to_s,              bp: bp.to_s,                
          c: c.to_s,              tap: tap.to_s,            m: m.to_s,
          fp: fp.to_s,            fr: fr.to_s,              mas_menos: mas_menos.to_s,
          v: v.to_s,              sm: sm.to_s
        }
        statistic.send("#{partido}=", values)
        statistic.played_games = statistic.played_games + 1 unless game.blank?
        statistic.save!
      end
    end
  end

  private
    def set_defaults
      values = {}
      FIELDS.zip(FIELDS_DEFAULT).each do |field, default|
        values[field] = default
      end
      (1..NUM_GAMES).each do |week|
        self.send("week_#{week}=", values)
      end
    end
end