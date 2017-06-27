# == Schema Information
#
# Table name: players
#
#

class Player < ActiveRecord::Base
  # !**************************************************
  # !                Associations
  # !**************************************************
  belongs_to :team
  has_many :statistics

  # !**************************************************
  # !                Validations
  # !**************************************************

  # !**************************************************
  # !                Callbacks
  # !**************************************************
  before_update :set_position

  # !**************************************************
  # !                  Other
  # !**************************************************
  scope :order_by_position, -> { order(%q{
                          case players.position
                            when 'base' then 1
                            when 'alero' then 2
                            when 'pivot' then 3
                          end
                        })
                  .order(:name) 
                }  
  include PlayerAllowed
  extend Enumerize
  enumerize :position, in: ["base", "alero", "pivot"], predicates: true
  
  def to_s
    name
  end

  def self.search(q, options={})
    where("name ILIKE ?", "%#{q}%").order( "name")
  end

  def print_price
    ActiveSupport::NumberHelper.number_to_delimited(price.to_i, :delimiter => ".")
  end

  def set_position
    unless position_detail.nil?
      self.position_detail = position_detail.parameterize.underscore
      self.position = position_detail
      self.position = "pivot" if self.position_detail == "Alapívot".parameterize.underscore
      self.position = "alero" if self.position_detail == "Escolta".parameterize.underscore
    end
  end

  # Getting Data
  def stat_field field
    statistics.by_season([CURRENT_SEASON]).send(field).to_f
  end

  def promedio_stat field
    statistics.by_season([CURRENT_SEASON]).promedio[field].to_f
  end

  def total_stat field
    statistics.by_season([CURRENT_SEASON]).total[field].to_f
  end

  def played_games
    statistics.by_season([CURRENT_SEASON]).played_games.to_i
  end

  def promedio_minutos
    statistics.by_season([CURRENT_SEASON]).promedio["min"].to_s.chop.to_f
  end

  def total_minutos
    statistics.by_season([CURRENT_SEASON]).total["min"].to_s.chop.to_f
  end

  def por_40_minutos field
   (promedio_stat(field) / promedio_minutos * 40).round(2)
  end

  def current_price
    price[CURRENT_ROUND]
  end

  def sube_15
    (( (( (current_price.to_i * 1.15) / 70000)) * (stat_field("played_games") + 1)) - total_stat("sm").to_f).round(2)
  end

  def baja_15
    (( (( (current_price.to_i * 0.85) / 70000)) * (stat_field("played_games") + 1)) - total_stat("sm").to_f).round(2)
  end

  def se_mantiene
    (( (( (current_price.to_i) * 1.to_f / 70000)) * (stat_field("played_games") + 1)) - total_stat("sm").to_f).round(2)
  end
  # Getting Data

  def to_param
    [id.to_s, name.parameterize].join("-")
  end

  # !**************************************************
  # !                Imports
  # !**************************************************
  def self.import_players
    players_url = Setting.find_by_key("players_url").value
    players_html = Nokogiri::HTML(open(players_url))

    players_html.css("table.listaJugadores > tr").each do |player_row|
      name = player_row.css('td[1]//text()').to_s
      team_name = player_row.css('td[2]/text()').to_s

      unless name.blank?
        unless player = Player.find_by_name(name)
          player = Player.new
        end
        player.name = name
        player.team = Team.where("name = ? OR second_name = ?", team_name, team_name).first

        player.href = Array.wrap(player_row.css("td[1]/a").map { |link| link['href'] })[0].to_s
        if player.valid?
          player.save!

          import_player player
        end
      end
    end
  end

  def self.import_player player
    players_url = player.href
    players_url.force_encoding('binary')
    players_url = WEBrick::HTTPUtils.escape(players_url)
    player_html = Nokogiri::HTML(open(players_url))

    player_html.css("td.fichaJugadorData").each do |player_data|
      position_detail = player_data.css('p[2]//text()').to_s
      height = player_data.css('p[3]/strong[1]/text()').to_s
      date_of_birth = player_data.css('p[5]/strong[1]/text()').to_s
      place_of_birth = player_data.css('p[5]/strong[2]/text()').to_s

      player.position_detail = position_detail
      player.height = height
      player.date_of_birth = date_of_birth
      player.place_of_birth = place_of_birth
    end
    player_html.css("td.fichaJugadorimg").each do |player_image|
      image = Array.wrap(player_image.css("img").map { |link| link['src'] })[0].to_s
      if image
        a_image = image.split('/')
        unless a_image.last.nil?
          a_image.last.gsub! '.jpg', '.png'
          player.image = a_image.last
        end
      end
    end
    player_html.css("table.fichaJugadorSM").each do |player_sm|
      price = player_sm.css('tr[3]/td[2]/text()')
      player.price["#{CURRENT_ROUND}"] = "#{price}".delete!('.').to_i
    end
    player.save!
  end

  def self.calculate_prices
    players_url = "http://www.rincondelmanager.com/smgr/stats.php?nombre="
    not_found_players = []
    current_round = Setting.find_by_key("current_round").value.to_i
    session_rounds = Setting.find_by_key("session_rounds").value.to_i

    Player.all.each do |player|
      row = 1
      escape_rows = 4
      player_url = WEBrick::HTTPUtils.escape(players_url + player.name)
      puts player_url
      if player_html = Nokogiri::HTML(open(player_url))
        prices = {}
        player_html.css("table.states-table > tbody > tr").each do |game_row|
          price_up_down = game_row.css("td[13] > text()").first.to_s.delete!('.').to_i
          round = game_row.css("td[1] > text()").to_s.to_i
          if row <= current_round  
            if (1..current_round).include?(round)
              prices[round] = price_up_down
              row = row + 1
            end
          end        
        end

        (current_round).downto(1) do |i|
          if player.price[i.to_s] and prices[i-1]
            if player.team.rest_round_1 == current_round.to_s or player.team.rest_round_2 == current_round.to_s
              player.price[(i - 1).to_s] = player.price[i.to_s]
            else
              player.price[(i - 1).to_s] = (player.price[i.to_s] + prices[i-1] * -1.to_i) 
            end
          else
            player.price[(i - 1).to_s] = 0
          end
        end
        player.save!
      else
        not_found_players << player
      end
    end
    puts "Not Found Players = "+not_found_players.count.to_s
    not_found_players.each do |p|
      puts p.name
    end
  end

  def self.import_numbers
    Team.all.each do |team|
      team_url = "http://www.acb.com/plantilla.php?cod_equipo=#{team.acb_short_code}&cod_competicion=LACB&cod_edicion=61"
      team_html = Nokogiri::HTML(open(team_url))
      team_html.css("table.plantilla tr").each do |player_data|
        number = player_data.css('td[1]/text()').to_s
        name = player_data.css('td[2]/a/text()').to_s
        if player = Player.find_by_name(name)
          player.number = number
          player.save!
        end
      end
    end
  end

end